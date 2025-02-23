//
//  CreateAssistantRequest.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-02-10.
//

import AsyncHTTPClient
import NIOHTTP1
import Foundation

struct CreateAssistantRequest: Request {
    let headers: HTTPHeaders = ["OpenAI-Beta" : "assistants=v2"]
    let method: HTTPMethod = .POST
    let path = "/assistants"
    let body: Data?

    init(
        model: String,
        name: String?,
        instructions: String?,
        reasoningEffort: Assistant.ReasoningEffort?,
        tools: [Assistant.Tool]?,
        metadata: [String : String]?,
        temperature: Double?,
        topP: Double?,
        responseFormat: ResponseFormat?
    ) throws {
        let body = Body(
            model: model,
            name: name,
            instructions: instructions,
            reasoningEffort: reasoningEffort,
            tools: tools,
            metadata: metadata,
            temperature: temperature,
            topP: topP,
            responseFormat: responseFormat
        )

        self.body = try Self.encoder.encode(body)
    }
}

extension CreateAssistantRequest {
    struct Body: Encodable {
        let model: String
        let name: String?
        let instructions: String?
        let reasoningEffort: Assistant.ReasoningEffort?
        let tools: [Assistant.Tool]?
        let metadata: [String : String]?
        let temperature: Double?
        let topP: Double?
        let responseFormat: ResponseFormat?
    }
}
