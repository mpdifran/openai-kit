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
        case number
        case array
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
}
