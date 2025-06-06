//
//  CreateResponseRequest.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-05-18.
//

import AsyncHTTPClient
import NIOHTTP1
import Foundation

public struct CreateResponseRequest: Request {
    let headers: HTTPHeaders = ["OpenAI-Beta" : "responses=v1"]
    let method: HTTPMethod = .POST
    let path = "/responses"
    let body: Data?

    init(
        input: [Response.InputItem],
        model: ModelID,
        instructions: String?,
        parallelToolCalls: Bool?,
        previousResponseID: String?,
        reasoning: Response.Reasoning?,
        store: Bool?,
        temperature: Double?,
        topP: Double?,
        text: Text?,
        toolChoice: Response.ToolChoice?,
        tools: [Response.Tool],
        truncation: Response.Truncation?,
        user: String?,
        stream: Bool?
    ) throws {
        let body = Body(
            input: input,
            model: model.id,
            instructions: instructions,
            parallelToolCalls: parallelToolCalls,
            previousResponseID: previousResponseID,
            reasoning: reasoning,
            store: store,
            temperature: temperature,
            topP: topP,
            text: text,
            toolChoice: toolChoice,
            tools: tools,
            truncation: truncation,
            user: user,
            stream: stream
        )

        self.body = try Self.encoder.encode(body)
    }
}

public extension CreateResponseRequest {
    struct Body: Encodable {
        let input: [Response.InputItem]
        let model: String
        let instructions: String?
        let parallelToolCalls: Bool?
        let previousResponseID: String?
        let reasoning: Response.Reasoning?
        let store: Bool?
        let temperature: Double?
        let topP: Double?
        let text: Text?
        let toolChoice: Response.ToolChoice?
        let tools: [Response.Tool]
        let truncation: Response.Truncation?
        let user: String?
        let stream: Bool?
    }
}
