import Foundation


protocol RequestHandler {
    var configuration: Configuration { get }
    func perform<T: Decodable>(request: Request) async throws -> T
    func stream<T: Decodable>(request: Request) async throws -> AsyncThrowingStream<T, Error>
}

extension RequestHandler {
    func generateURL(for request: Request) throws -> String {
        var components = URLComponents()
        components.scheme = request.scheme?.value ?? configuration.api.scheme.value
        components.host = request.host ?? configuration.api.host
        components.path = [configuration.api.path, request.path]
            .compactMap { $0 }
            .joined()

        components.queryItems = request.queryItems

        guard let url = components.url else {
            throw RequestHandlerError.invalidURLGenerated
        }
    
        return url.absoluteString
    }
}
