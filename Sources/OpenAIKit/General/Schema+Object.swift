//
//  SchemaObject.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-03-03.
//

extension Schema {
    public struct Object: Codable, Equatable, Sendable {
        public let type: ObjectType
        public let properties: [String: Parameter]
        public let required: [String]
        public let additionalProperties: Bool
        public let references: [String: Object]?

        public init(
            properties: [String: Parameter],
            references: [String: Object]? = nil
        ) {
            self.type = .object
            self.properties = properties
            self.required = properties.keys.sorted()
            self.additionalProperties = false
            self.references = references
        }

        public init(
            type: ObjectType = .object,
            properties: [String: Parameter],
            required: [String],
            additionalProperties: Bool = false,
            references: [String: Object]? = nil
        ) {
            self.type = type
            self.properties = properties
            self.required = required
            self.additionalProperties = additionalProperties
            self.references = references
        }

        enum CodingKeys: String, CodingKey {
            case type
            case properties
            case required
            case additionalProperties
            case references = "$defs"
        }
    }

    public enum ObjectType: String, Codable, Equatable, Sendable {
        case object
    }
}
