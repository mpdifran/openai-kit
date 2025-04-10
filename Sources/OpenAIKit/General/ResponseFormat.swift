//
//  Content.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-02-10.
//

public extension ResponseFormat {
    enum `Type`: Codable, Equatable {
        case auto
        case text
        case jsonObject
        case jsonSchema(ResponseSchema)
    }
}

public struct ResponseFormat: Codable, Equatable {
    public let type: `Type`

    public init(type: Type) {
        self.type = type
    }

    public init(from decoder: Decoder) throws {
        if
            let singleValueContainer = try? decoder.singleValueContainer(),
            let _ = try? singleValueContainer.decode(String.self)
        {
            self.type = .auto
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let typeString = try container.decode(String.self, forKey: .type)

            switch typeString {
            case "auto":
                self.type = .auto
            case "text":
                self.type = .text
            case "json_object":
                self.type = .jsonObject
            case "json_schema":
                let schema = try container.decode(ResponseSchema.self, forKey: .jsonSchema)
                self.type = .jsonSchema(schema)
            default:
                throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Invalid response format type.")
            }
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self.type {
        case .auto:
            var container = encoder.singleValueContainer()
            try container.encode("auto")
        case .text:
            try container.encode("text", forKey: .type)
        case .jsonObject:
            try container.encode("json_object", forKey: .type)
        case .jsonSchema(let schema):
            try container.encode("json_schema", forKey: .type)
            try container.encode(schema, forKey: .jsonSchema)
        }
    }

    enum CodingKeys: String, CodingKey {
        case type
        case jsonSchema
    }
}
