//
//  Message.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-02-10.
//

import Foundation

public struct Message: Codable {
    let id: String
    let threadId: String
    let assistantId: String?
    let runId: String?
    let status: Status
    let incompleteDetails: IncompleteDetails?
    let role: Role
    let metadata: [String : String]
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
        let reason: String
    }
}
