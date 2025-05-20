//
//  Function.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-05-18.
//

import Foundation

public struct Function: Codable, Hashable, Sendable {
    public let type: `Type`
    public let name: String
    public let description: String?
    public let parameters: Schema.Object?
    public let strict: Bool

    public init(
        name: String,
        description: String? = nil,
        parameters: Schema.Object? = nil,
        strict: Bool = true
    ) {
        self.type = .function
        self.name = name
        self.description = description
        self.parameters = parameters
        self.strict = strict
    }
}

public extension Function {
    enum `Type`: String, Codable, Hashable, Sendable {
        case function
    }
}
