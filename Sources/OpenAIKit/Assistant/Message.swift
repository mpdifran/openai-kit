//
//  Message.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-02-10.
//

import Foundation

public struct Message: Codable {
    public let id: String
    public let threadId: String
    public let assistantId: String?
    public let runId: String?
    public let status: Status
    public let incompleteDetails: IncompleteDetails?
    public let role: Role
    public let metadata: [String : String]
}

public extension Message {
    enum Status: String, Codable {
        case inProgress = "in_progress"
        case incomplete = "incomplete"
        case completed = "completed"
    }

    enum Role: String, Codable {
        case user
        case assistant
    }

    struct IncompleteDetails: Codable {
        public let reason: String
    }
}
