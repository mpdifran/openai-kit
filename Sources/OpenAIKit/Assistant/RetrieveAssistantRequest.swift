//
//  RetrieveAssistantRequest.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-02-15.
//

import AsyncHTTPClient
import NIOHTTP1
import Foundation

struct RetrieveAssistantRequest: Request {
    let headers: HTTPHeaders = ["OpenAI-Beta" : "assistants=v2"]
    let method: HTTPMethod = .GET
    let path: String

    init(assistantID: String) {
        self.path = "/assistants/\(assistantID)"
    }
}
