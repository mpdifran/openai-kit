//
//  DeleteThreadRequest.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-02-13.
//

import AsyncHTTPClient
import NIOHTTP1
import Foundation

struct DeleteThreadRequest: Request {
    let headers: HTTPHeaders = ["OpenAI-Beta" : "assistants=v2"]
    let method: HTTPMethod = .DELETE
    let path: String

    init(threadID: String) {
        self.path = "/threads/\(threadID)"
    }
}
