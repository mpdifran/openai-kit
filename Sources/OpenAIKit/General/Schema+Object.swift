//
//  SchemaObject.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-03-03.
//

public extension Schema {
    struct Object: Codable, Equatable {
        public let type: ObjectType
        public let properties: [String : Parameter]
        public let required: [String]
        public let additionalProperties: Bool

        public init(properties: [String : Parameter]) {
            self.type = .object
            self.properties = properties
            self.required = Array(properties.keys)
            self.additionalProperties = false
        }

        public init(
            type: ObjectType = .object,
            properties: [String : Parameter],
            required: [String],
            additionalProperties: Bool = false
        ) {
            self.type = type
            self.properties = properties
            self.required = required
            self.additionalProperties = additionalProperties
        }
    }

    enum ObjectType: String, Codable, Equatable {
        case object
    }
}
