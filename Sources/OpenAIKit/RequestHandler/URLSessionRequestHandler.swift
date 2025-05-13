import Foundation

#if !os(Linux)
    struct URLSessionRequestHandler: RequestHandler {
        let session: URLSession
        let configuration: Configuration
        let decoder: JSONDecoder

        init(
            session: URLSession,
            configuration: Configuration,
            decoder: JSONDecoder = JSONDecoder()
        ) {
            self.session = session
            self.configuration = configuration
            self.decoder = decoder
        }

        func perform<T>(request: Request) async throws -> T where T: Decodable {
            let urlRequest = try makeUrlRequest(request: request)
            let (data, _) = try await session.data(for: urlRequest)
            decoder.keyDecodingStrategy = request.keyDecodingStrategy
            decoder.dateDecodingStrategy = request.dateDecodingStrategy
            do {
                return try decoder.decode(T.self, from: data)
            } catch let decodingError {
                let apiError: APIErrorResponse
                do {
                    apiError = try decoder.decode(APIErrorResponse.self, from: data)
                } catch {
                    throw decodingError
                }
                throw apiError
            }
        }

        func stream<T: Sendable>(request: Request) async throws -> AsyncThrowingStream<T, Error>
        where T: Decodable {
            var urlRequest = try makeUrlRequest(request: request)
            urlRequest.timeoutInterval = 25
            decoder.keyDecodingStrategy = request.keyDecodingStrategy
            decoder.dateDecodingStrategy = request.dateDecodingStrategy

            return AsyncThrowingStream<T, Error> { [urlRequest] continuation in
                Task(priority: .userInitiated) {
                    do {
                        let (bytes, _) = try await session.bytes(for: urlRequest)
                        for try await buffer in bytes.lines {
                            let text = buffer
                            let segments = text.components(separatedBy: "data: ")
                            for segment in segments {
                                let trimmed = segment.trimmingCharacters(in: .whitespacesAndNewlines)
                                guard !trimmed.isEmpty else { continue }

                                // Detect end of stream
                                if trimmed == "[DONE]" {
                                    continuation.finish()
                                    return
                                }

                                // Decode and yield valid JSON frames
                                guard let jsonData = trimmed.data(using: .utf8),
                                      let value = try? decoder.decode(T.self, from: jsonData) else {
                                    continue
                                }
                                continuation.yield(value)
                            }
                        }
                        continuation.finish()
                    } catch {
                        continuation.finish(throwing: error)
                    }
                }
            }
        }

        private func makeUrlRequest(request: Request) throws -> URLRequest {
            let urlString = try generateURL(for: request)
            guard let url = URL(string: urlString) else {
                throw RequestHandlerError.invalidURLGenerated
            }
            var urlRequest = URLRequest(url: url)
            for (key, value) in configuration.headers {
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
            for (key, value) in request.headers {
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
            urlRequest.httpMethod = request.method.rawValue
            urlRequest.httpBody = request.body
            return urlRequest
        }
    }
#endif
