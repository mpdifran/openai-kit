//
//  Text.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-05-18.
//

import Foundation

public struct Text: Encodable {
    public let format: Format?

    public init(format: Format?) {
        self.format = format
    }
}

public struct Format: Encodable {
    public enum `Type`: Codable, Hashable, Sendable {
        case auto
        case text
        case jsonObject
        case jsonSchema(ResponseSchema)
    }

    public let type: `Type`

    public init(type: `Type`) {
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
                // Decode the entire object as ResponseSchema
                let schema = try ResponseSchema(from: decoder)
                self.type = .jsonSchema(schema)
            default:
                throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Invalid response format type.")
            }
        }
    }

    public func encode(to encoder: Encoder) throws {
        switch self.type {
        case .auto:
            var container = encoder.singleValueContainer()
            try container.encode("auto")
        case .text:
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode("text", forKey: .type)
        case .jsonObject:
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode("json_object", forKey: .type)
        case .jsonSchema(let schema):
            // Encode the schema properties directly at the same level as "type"
            try schema.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode("json_schema", forKey: .type)
        }
    }

    enum CodingKeys: String, CodingKey {
        case type
    }
}
