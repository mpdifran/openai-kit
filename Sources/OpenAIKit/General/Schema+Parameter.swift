//
//  SchemaParameter.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-03-03.
//

public extension Schema {
    struct Parameter: Codable, Equatable {
        public let type: ParameterType
        public let description: String
        public let `enum`: [String]?
        public let items: Object?

        public init(
            description: String,
            arrayOf items: Schema.Object
        ) {
            self.type = .array
            self.description = description
            self.enum = nil
            self.items = items
        }

        public init(
            description: String,
            optionalArrayOf items: Schema.Object
        ) {
            self.type = .optionalArray
            self.description = description
            self.enum = nil
            self.items = items
        }

        public init(
            type: ParameterType,
            description: String,
            enum: [String]? = nil,
            items: Object? = nil
        ) {
            self.type = type
            self.description = description
            self.enum = `enum`
            self.items = items
        }
    }

    enum ParameterType: String, Codable, Equatable {
        case string
        case optionalString
        case number
        case optionalNumber
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
            case .array:
                try container.encode("array")
            case .optionalArray:
                try container.encode(["array", "null"])
            }
        }
    }
}

public extension Schema.Parameter {
    init<T: RawRepresentable & CaseIterable>(
        enum enumType: T.Type,
        description: String
    ) where T.RawValue == String {
        self.type = .string
        self.description = description
        self.enum = enumType.allCases.map { $0.rawValue }
        self.items = nil
    }

    init<T: RawRepresentable & CaseIterable>(
        optionalEnum enumType: T.Type,
        description: String
    ) where T.RawValue == String {
        self.type = .optionalString
        self.description = description
        self.enum = enumType.allCases.map { $0.rawValue }
        self.items = nil
    }
}
