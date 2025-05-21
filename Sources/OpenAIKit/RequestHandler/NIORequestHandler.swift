import AsyncHTTPClient
import Foundation
import NIO
import NIOFoundationCompat
import NIOHTTP1

struct NIORequestHandler: RequestHandler {
    let httpClient: HTTPClient
    let configuration: Configuration
    let decoder: JSONDecoder

    init(
        httpClient: HTTPClient,
        configuration: Configuration,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.httpClient = httpClient
        self.configuration = configuration
        self.decoder = decoder
    }

    func perform<T: Decodable>(request: Request) async throws -> T {
        var headers = configuration.headers

        headers.add(contentsOf: request.headers)

        let url = try generateURL(for: request)

        let body: HTTPClient.Body? = {
            guard let data = request.body else { return nil }
            return .data(data)
        }()

        let response = try await httpClient.execute(
            request: HTTPClient.Request(
                url: url,
                method: request.method,
                headers: headers,
                body: body
            )
        ).get()

        guard let byteBuffer = response.body else {
            throw RequestHandlerError.responseBodyMissing
        }

        decoder.keyDecodingStrategy = request.keyDecodingStrategy
        decoder.dateDecodingStrategy = request.dateDecodingStrategy

        do {
            return try decoder.decode(T.self, from: byteBuffer)
        } catch let decodingError {
            let apiError: APIErrorResponse
            do {
                apiError = try decoder.decode(APIErrorResponse.self, from: byteBuffer)
            } catch {
                throw decodingError
            }
            throw apiError
        }
    }

    func stream<T: Decodable & Sendable>(request: Request) async throws -> AsyncThrowingStream<
        T, Error
    > {

        let url = try generateURL(for: request)

        var httpClientRequest = HTTPClientRequest(url: url)

        httpClientRequest.headers.add(contentsOf: configuration.headers)
        httpClientRequest.headers.add(contentsOf: request.headers)

        httpClientRequest.method = request.method

        if let body = request.body {
            httpClientRequest.body = .bytes(body)
        }

        decoder.keyDecodingStrategy = request.keyDecodingStrategy
        decoder.dateDecodingStrategy = request.dateDecodingStrategy

        let response = try await httpClient.execute(httpClientRequest, timeout: .seconds(25))

        return AsyncThrowingStream<T, Error> { continuation in
            var pending = ""
            Task(priority: .userInitiated) {
                do {
                    for try await buffer in response.body {
                        let text = String(buffer: buffer)

                        print("[TRACE] Raw text buffer: \(text)")

                        // Append to the buffer, and break up by newline. A complete frame will have 2 newlines at the end. This means lines.last will either be an empty string, or an incomplete frame.
                        pending += text
                        let lines = pending.components(separatedBy: .newlines)
                        pending = lines.last ?? ""

                        let completeLines = lines.dropLast()

                        for line in completeLines {
                            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
                            guard trimmed.hasPrefix("data: ") else { continue }

                            let dataValue = trimmed.replacingOccurrences(of: "data: ", with: "")

                            // Detect end of stream
                            if dataValue == "[DONE]" {
                                continuation.finish()
                                return
                            }

                            // Decode and yield valid JSON frames
                            guard let jsonData = dataValue.data(using: .utf8) else {
                                continue
                            }

                            do {
                                let value = try decoder.decode(T.self, from: jsonData)
                                continuation.yield(value)
                            } catch {
                                print("[TRACE] Could not decode event: \(dataValue)")
                                print("Decoding Error: \(error)")
                            }

//                            guard
//                                let jsonData = dataValue.data(using: .utf8),
//                                let value = try? decoder.decode(T.self, from: jsonData)
//                            else {
//                                print("[TRACE] Could not decode event: \(dataValue)")
//                              print()
//                                continue
//                            }
//
//                            continuation.yield(value)
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }

}
