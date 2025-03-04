//
//  Assistant.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-02-10.
//

import Foundation

public struct Assistant: Codable, Equatable {
    public let id: String
    public let name: String?
    public let description: String?
    public let model: String
    public let instructions: String?
    public let temperature: Double?
    public let topP: Double?
    public let tools: [Tool]
    public let metadata: [String: String]
}

extension Assistant {
    public enum ReasoningEffort: String, Codable {
        case low
        case medium
        case high
    }

    public struct Tool: Codable, Equatable, Sendable {
        public let type: ToolType
        public let function: Function?

        public static let codeInterpreter = Tool(
            type: .codeInterpreter,
            function: nil
        )

        public static func function(_ function: Function) -> Tool {
            Tool(type: .function, function: function)
        }
    }

    public enum ToolType: String, Codable, Equatable, Sendable {
        case codeInterpreter = "code_interpreter"
        //        case fileSearch = "file_search"
        case function
    }
}

extension Assistant.Tool {
    public struct Function: Codable, Equatable, Sendable {
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
            self.name = name
            self.description = description
            self.parameters = parameters
            self.strict = strict
        }
    }
}
