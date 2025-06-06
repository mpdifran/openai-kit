//
//  SchemaParameter.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-03-03.
//

extension Schema {
    public struct Parameter: Codable, Hashable, Sendable {
        public let type: ParameterType?
        public let description: String?
        public let `enum`: [String]?
        public let items: Item?
        public let ref: String?

        public init(
            description: String,
            arrayOf items: Schema.Item
        ) {
            self.type = .array
            self.description = description
            self.enum = nil
            self.items = items
            self.ref = nil
        }

        public init(
            description: String,
            optionalArrayOf items: Schema.Item
        ) {
            self.type = .optionalArray
            self.description = description
            self.enum = nil
            self.items = items
            self.ref = nil
        }

        /// Pass the name of the reference defined in ``Schema.Object.references``. The correct formatting will be applied.
        public init(
            ref: String
        ) {
            self.ref = "#/$defs/\(ref)"
            self.type = nil
            self.description = nil
            self.enum = nil
            self.items = nil
        }

        public init(
            type: ParameterType,
            description: String,
            enum: [String]? = nil,
            items: Item? = nil
        ) {
            self.type = type
            self.description = description
            self.enum = `enum`
            self.items = items
            self.ref = nil
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            if let ref = try? container.decode(String.self, forKey: .ref) {
                self.ref = ref
                self.type = nil
                self.description = nil
                self.enum = nil
                self.items = nil
            } else {
                // If it's not a ref, type should be there.
                self.type = try container.decode(ParameterType.self, forKey: .type)
                self.description = try container.decodeIfPresent(String.self, forKey: .description)
                self.enum = try container.decodeIfPresent([String].self, forKey: .enum)
                if container.contains(.items) {
                    let itemsDecoder = try container.superDecoder(forKey: .items)
                    if let object = try? Schema.Object(from: itemsDecoder) {
                        self.items = .object(object)
                    } else if let parameter = try? Schema.Parameter(from: itemsDecoder) {
                        self.items = .parameter(parameter)
                    } else {
                        throw DecodingError.typeMismatch(
                            Schema.Item.self,
                            DecodingError.Context(
                                codingPath: decoder.codingPath + [CodingKeys.items],
                                debugDescription: "Unable to decode items as Schema.Item"
                            )
                        )
                    }
                } else {
                    self.items = nil
                }
                self.ref = nil
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            if let ref {
                try container.encode(ref, forKey: .ref)
            } else {
                try container.encode(type, forKey: .type)
                try container.encodeIfPresent(description, forKey: .description)
                try container.encodeIfPresent(`enum`, forKey: .enum)
                if let items = self.items {
                    let itemsEncoder = container.superEncoder(forKey: .items)
                    switch items {
                    case .object(let object):
                        try object.encode(to: itemsEncoder)
                    case .parameter(let parameter):
                        try parameter.encode(to: itemsEncoder)
                    }
                }
            }
        }

        enum CodingKeys: String, CodingKey {
            case type
            case description
            case `enum`
            case items
            case ref = "$ref"
        }
    }

    public enum ParameterType: String, Codable, Equatable, Sendable {
        case string
        case optionalString
        case number
        case optionalNumber
        case integer
        case optionalInteger
        case array
        case optionalArray

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let value = try? container.decode([String].self) {
                let optional = value.contains("null")

                if value.contains("string") {
                    self = optional ? .optionalString : .string
                } else if value.contains("number") {
                    self = optional ? .optionalNumber : .number
                } else if value.contains("integer") {
                    self = optional ? .optionalInteger : .integer
                } else if value.contains("array") {
                    self = optional ? .optionalArray : .array
                } else {
                    throw DecodingError.dataCorruptedError(
                        in: container,
                        debugDescription: "Invalid ParameterType value: \(value)"
                    )
                }
            } else {
                let value = try container.decode(String.self)

                switch value {
                case "string":
                    self = .string
                case "number":
                    self = .number
                case "integer":
                    self = .integer
                case "array":
                    self = .array
                default:
                    throw DecodingError.dataCorruptedError(
                        in: container,
                        debugDescription: "Invalid ParameterType value: \(value)"
                    )
                }
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
            case .string:
                try container.encode("string")
            case .optionalString:
                try container.encode(["string", "null"])
            case .number:
                try container.encode("number")
            case .optionalNumber:
                try container.encode(["number", "null"])
            case .integer:
                try container.encode("integer")
            case .optionalInteger:
                try container.encode(["integer", "null"])
            case .array:
                try container.encode("array")
            case .optionalArray:
                try container.encode(["array", "null"])
            }
        }
    }
}

public extension Schema {
    indirect enum Item: Codable, Hashable, Sendable {
        case object(Schema.Object)
        case parameter(Schema.Parameter)
    }
}

extension Schema.Parameter {
    public init<T: RawRepresentable & CaseIterable>(
        enum enumType: T.Type,
        description: String
    ) where T.RawValue == String {
        self.type = .string
        self.description = description
        self.enum = enumType.allCases.map { $0.rawValue }
        self.items = nil
        self.ref = nil
    }

    public init<T: RawRepresentable & CaseIterable>(
        optionalEnum enumType: T.Type,
        description: String
    ) where T.RawValue == String {
        self.type = .optionalString
        self.description = description
        self.enum = enumType.allCases.map { $0.rawValue }
        self.items = nil
        self.ref = nil
    }
}
