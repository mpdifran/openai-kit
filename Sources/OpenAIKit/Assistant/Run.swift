//
//  Run.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-02-11.
//

import Foundation

public struct Run: Codable {
    let id: String
    let threadId: String
    let assistantId: String
    let status: Status
    let requiredAction: RequiredAction?
    let lastError: LastError?
    let incompleteDetails: IncompleteDetails?
    let model: String
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
        let submitToolOutputs: SubmitToolOutputs
    }

    struct SubmitToolOutputs: Codable {
        let toolCalls: [ToolCall]
    }

    struct ToolCall: Codable {
        let id: String
        let function: Function
    }

    struct Function: Codable {
        let name: String
        let arguments: String
    }

    struct LastError: Codable {
        let code: ErrorCode
        let message: String
    }

    enum ErrorCode: String, Codable {
        case serverError = "server_error"
        case rateLimitExceeded = "rate_limit_exceeded"
        case invalidPrompt = "invalid_prompt"
    }

    struct IncompleteDetails: Codable {
        let reason: String
    }
}
