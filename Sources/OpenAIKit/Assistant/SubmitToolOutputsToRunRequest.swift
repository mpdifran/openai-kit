//
//  SubmitToolOutputsToRunRequest.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-02-11.
//

import AsyncHTTPClient
import NIOHTTP1
import Foundation

struct SubmitToolOutputsToRunRequest: Request {
    let headers: HTTPHeaders = ["OpenAI-Beta" : "assistants=v2"]
    let method: HTTPMethod = .POST
    let path: String
    let body: Data?

    init(
        threadID: String,
        runID: String,
        toolOutputs: [ToolOutput],
        stream: Bool = false
    ) throws {
        self.path = "/threads/\(threadID)/runs/\(runID)/submit_tool_outputs"

        let body = Body(
            toolOutputs: toolOutputs,
            stream: stream
        )

        self.body = try Self.encoder.encode(body)
    }
}

extension SubmitToolOutputsToRunRequest {
    struct Body: Encodable {
        let toolOutputs: [ToolOutput]
        let stream: Bool
    }
}
