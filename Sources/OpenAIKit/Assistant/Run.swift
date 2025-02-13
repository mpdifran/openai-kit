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
        case inProgress
        case requiresAction
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
        case serverError
        case rateLimitExceeded
        case invalidPrompt
    }

    struct IncompleteDetails: Codable {
        public let reason: String
    }
}
