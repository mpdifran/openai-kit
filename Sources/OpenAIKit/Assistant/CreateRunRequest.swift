//
//  CreateRunRequest.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-02-11.
//

import AsyncHTTPClient
import NIOHTTP1
import Foundation

struct CreateRunRequest: Request {
    let headers: HTTPHeaders = ["OpenAI-Beta" : "assistants=v2"]
    let method: HTTPMethod = .POST
    let path: String
    let body: Data?

    init(
        threadID: String,
        assistantID: String,
        tools: [Assistant.Tool]?,
        toolChoice: Run.ToolChoice?
    ) throws {
        self.path = "/threads/\(threadID)/runs"

        let body = Body(
            assistantId: assistantID,
            tools: tools,
            toolChoice: toolChoice
        )

        self.body = try Self.encoder.encode(body)
    }
}

extension CreateRunRequest {
    struct Body: Encodable {
        let assistantId: String
        let tools: [Assistant.Tool]?
        let toolChoice: Run.ToolChoice?
    }
}
