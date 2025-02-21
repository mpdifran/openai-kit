//
//  Run.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-02-11.
//

import Foundation

public struct Run: Codable {
    public let id: String
    public let threadId: String
    public let assistantId: String
    public let status: Status
    public let requiredAction: RequiredAction?
    public let lastError: LastError?
    public let incompleteDetails: IncompleteDetails?
    public let model: String
}

public extension Run {
    enum Status: String, Codable {
        case queued
        case inProgress = "in_progress"
        case requiresAction = "requires_action"
        case cancelling
        case cancelled
        case failed
        case completed
        case incomplete
        case expired
    }

    struct RequiredAction: Codable {
        public let submitToolOutputs: SubmitToolOutputs
    }

    struct SubmitToolOutputs: Codable {
        public let toolCalls: [ToolCall]
    }

    struct ToolCall: Codable {
        public let id: String
        public let function: Function
    }

    struct Function: Codable {
        public let name: String
        public let arguments: String
    }

    struct LastError: Codable {
        public let code: ErrorCode
        public let message: String
    }

    enum ErrorCode: String, Codable {
        case serverError = "server_error"
        case rateLimitExceeded = "rate_limit_exceeded"
        case invalidPrompt = "invalid_prompt"  
    }

    struct IncompleteDetails: Codable {
        public let reason: String
    }

    enum ToolChoice: Codable {
        case none
        case auto
        case required
        case function(String)
    }
}

extension Run.ToolChoice {
    private enum CodingKeys: String, CodingKey {
        case type
        case function
    }

    private enum FunctionKeys: String, CodingKey {
        case name
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let stringValue = try? container.decode(String.self) {
            switch stringValue {
            case "none":
                self = .none
            case "auto":
                self = .auto
            case "required":
                self = .required
            default:
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Unexpected string value for ToolChoice: \(stringValue)"
                )
            }
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(String.self, forKey: .type)

            guard type == "function" else {
                throw DecodingError.dataCorruptedError(
                    forKey: .type,
                    in: container,
                    debugDescription: "Unexpected type for ToolChoice: \(type)"
                )
            }

            let functionContainer = try container.nestedContainer(keyedBy: FunctionKeys.self, forKey: .function)
            let functionName = try functionContainer.decode(String.self, forKey: .name)
            self = .function(functionName)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .none:
            try container.encode("none")
        case .auto:
            try container.encode("auto")
        case .required:
            try container.encode("required")
        case .function(let functionName):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode("function", forKey: .type)

            var functionContainer = container.nestedContainer(keyedBy: FunctionKeys.self, forKey: .function)
            try functionContainer.encode(functionName, forKey: .name)
        }
    }
}
