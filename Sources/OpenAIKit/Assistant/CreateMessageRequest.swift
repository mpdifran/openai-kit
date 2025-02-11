//
//  CreateMessageRequest.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-02-10.
//

import AsyncHTTPClient
import NIOHTTP1
import Foundation

struct CreateMessageRequest: Request {
    let method: HTTPMethod = .POST
    let path: String
    let body: Data?

    init(
        threadID: String,
        message: Thread.Message
    ) throws {
        self.path = "v1/threads/\(threadID)/messages"

        self.body = try Self.encoder.encode(message)
    }
}
