//
//  RetrieveRunRequest.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-02-11.
//

import AsyncHTTPClient
import NIOHTTP1
import Foundation

struct RetrieveRunRequest: Request {
    let headers: HTTPHeaders = ["OpenAI-Beta" : "assistants=v2"]
    let method: HTTPMethod = .GET
    let path: String
    let body: Data?

    init(
        threadID: String,
        runID: String
    ) {
        self.path = "/threads/\(threadID)/runs/\(runID)"
        self.body = nil
    }
}
