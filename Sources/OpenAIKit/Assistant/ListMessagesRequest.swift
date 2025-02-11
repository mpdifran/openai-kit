//
//  ListMessagesRequest.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-02-11.
//

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
    let method: HTTPMethod = .GET
    let path: String
    let body: Data?

    init(
        threadID: String,
        runID: String?
    ) {
        if let runID {
            self.path = "v1/threads/\(threadID)/messages?run_id=\(runID)"
        } else {
            self.path = "v1/threads/\(threadID)/messages"
        }
        self.body = nil
    }
}
