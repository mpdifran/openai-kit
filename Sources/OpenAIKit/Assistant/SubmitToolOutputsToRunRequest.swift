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
    let method: HTTPMethod = .POST
    let path: String
    let body: Data?

    init(
        threadID: String,
        runID: String,
        toolOutputs: [ToolOutput]
    ) throws {
        self.path = "/v1/threads/\(threadID)/runs/\(runID)/submit_tool_outputs"

        let body = Body(toolOutputs: toolOutputs)

        self.body = try Self.encoder.encode(body)
    }
}

extension SubmitToolOutputsToRunRequest {
    struct Body: Encodable {
        let toolOutputs: [ToolOutput]
    }
}
