//
//  DeletedResponse.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-02-13.
//

import Foundation

public struct DeletedResponse: Codable {
    public let id: String
    public let object: ObjectType
    public let deleted: Bool

    public init(
        id: String,
        object: ObjectType,
        deleted: Bool
    ) {
        self.id = id
        self.object = .assistantDeleted
        self.deleted = deleted
    }

    public enum ObjectType: String, Codable {
        case assistantDeleted = "assistant.deleted"
        case threadDeleted = "thread.deleted"
    }
}
