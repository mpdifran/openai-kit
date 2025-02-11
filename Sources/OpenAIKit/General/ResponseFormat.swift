//
//  Content.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-02-10.
//

public extension ResponseFormat {
    enum `Type`: String, Codable {
        case auto = "auto"
        case text = "text"
        case jsonObject = "json_object"
    }
}

public struct ResponseFormat: Codable {
    public let type: `Type`

    public init(type: Type) {
        self.type = type
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.singleValueContainer(),
           let value = try? container.decode(String.self),
           let type = Type(rawValue: value) {
            self.type = type
            return
        }

        let container = try decoder.container(keyedBy: CodingKeys.self)
        let value = try container.decode(String.self, forKey: .type)
        guard let type = Type(rawValue: value) else {
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Invalid response format type.")
        }

        self.type = type
    }

    public func encode(to encoder: Encoder) throws {
        // We need a custom encoder / decoder because this API is a mess.
        switch type {
        case .auto:
            var container = encoder.singleValueContainer()
            try container.encode(type.rawValue)
        case .text, .jsonObject:
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(type.rawValue, forKey: .type)
        }
    }

    enum CodingKeys: String, CodingKey {
        case type
    }
}
