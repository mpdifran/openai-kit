//
//  Assistant.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-02-10.
//

import Foundation

public struct Assistant: Codable {
    public let id: String
    public let name: String?
    public let description: String?
    public let model: String
    public let instructions: String?
    public let temperature: Double?
    public let topP: Double?
    public let metadata: [String : String]
}

public extension Assistant {
    enum ReasoningEffort: String, Codable {
        case low
        case medium
        case high
    }

    struct Tool: Codable {
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

    enum ToolType: String, Codable {
        case codeInterpreter = "code_interpreter"
//        case fileSearch = "file_search"
        case function
    }
}

public extension Assistant.Tool {
    struct Function: Codable {
        public let name: String
        public let description: String?
        public let parameters: Parameters?
        public let strict: Bool

        public init(
            name: String,
            description: String? = nil,
            parameters: Parameters? = nil,
            strict: Bool = true
        ) {
            self.name = name
            self.description = description
            self.parameters = parameters
            self.strict = strict
        }
    }
}

public extension Assistant.Tool.Function {
    struct Parameters: Codable {
        public let type: ParametersType
        public let properties: [String : Parameter]
        public let required: [String]
        public let additionalProperties: Bool

        public init(
            type: ParametersType = .object,
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

    enum ParametersType: String, Codable {
        case object
    }

    struct Parameter: Codable {
        public let type: ParameterType
        public let description: String

        public init(type: ParameterType, description: String) {
            self.type = type
            self.description = description
        }
    }

    enum ParameterType: String, Codable {
        case string
        case number
    }
}
