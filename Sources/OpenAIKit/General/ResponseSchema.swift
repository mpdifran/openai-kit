//
//  ResponseSchema.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-03-03.
//

public struct ResponseSchema: Codable {
    public let name: String
    public let description: String?
    public let strict: Bool
    public let schema: Object

    public init(
        name: String,
        description: String? = nil,
        strict: Bool = true,
        schema: Object
    ) {
        self.name = name
        self.description = description
        self.strict = strict
        self.schema = schema
    }
}

// TODO: Look into sharing this with Assistant Function definitions.
public extension ResponseSchema {
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

    struct Parameter: Codable, Equatable {
        public let type: ParameterType
        public let description: String
        public let `enum`: [String]?
        public let items: [Object]?

        public init(
            type: ParameterType,
            description: String,
            enum: [String]? = nil,
            items: [Object]? = nil
        ) {
            self.type = type
            self.description = description
            self.enum = `enum`
            self.items = items
        }
    }

    enum ParameterType: String, Codable, Equatable {
        case string
        case number
        case array
    }
}
