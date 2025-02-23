//
//  ListMessagesRequest.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-02-11.
//

import AsyncHTTPClient
import NIOHTTP1
import Foundation

struct ListMessagesRequest: Request {
    let headers: HTTPHeaders = ["OpenAI-Beta" : "assistants=v2"]
    let method: HTTPMethod = .GET
    let path: String
    let queryItems: [URLQueryItem]?
    let body: Data?

    init(
        threadID: String,
        runID: String?
    ) {
        if let runID {
            queryItems = [URLQueryItem(name: "run_id", value: runID)]
        } else {
            queryItems = nil
        }

        self.path = "/threads/\(threadID)/messages"
        self.body = nil
    }
}
