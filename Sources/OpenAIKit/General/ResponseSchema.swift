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
    public let schema: Schema.Object

    public init(
        name: String,
        description: String? = nil,
        strict: Bool = true,
        schema: Schema.Object
    ) {
        self.name = name
        self.description = description
        self.strict = strict
        self.schema = schema
    }
}
