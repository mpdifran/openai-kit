import AsyncHTTPClient
import NIOHTTP1
import Foundation

protocol Request {
    var method: HTTPMethod { get }
    var scheme: API.Scheme? { get }
    var host: String? { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
    var headers: HTTPHeaders { get }
    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy { get }
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get }
}

extension Request {
    static var encoder: JSONEncoder { .requestEncoder }

    var scheme: API.Scheme? { nil }
    var host: String? { nil }
    var body: Data? { nil }

    var queryItems: [URLQueryItem]? { nil }
    var headers: HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: "application/json")
        return headers
    }

    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy { .convertFromSnakeCase }
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { .secondsSince1970 }
}

extension JSONEncoder {
    static var requestEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .custom { codingKeys in
            guard let lastKey = codingKeys.last else { return AnyCodingKey(stringValue: "") }

            guard lastKey.intValue == nil else {
                return lastKey
            }

            let keyString = lastKey.stringValue

            // Preserve known camelCase keys
            let exceptions = ["additionalProperties"]
            if exceptions.contains(keyString) {
                return lastKey
            }

            // Convert to snake_case otherwise
            let snakeCase = keyString.replacingOccurrences(
                of: "([a-z])([A-Z])",
                with: "$1_$2",
                options: .regularExpression
            ).lowercased()

            return AnyCodingKey(stringValue: snakeCase)
        }
        return encoder
    }
}

struct AnyCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }

    init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}
