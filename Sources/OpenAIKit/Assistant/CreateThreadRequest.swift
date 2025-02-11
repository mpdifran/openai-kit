//
//  CreateThreadRequest.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-02-10.
//

import AsyncHTTPClient
import NIOHTTP1
import Foundation

struct CreateThreadRequest: Request {
    let method: HTTPMethod = .POST
    let path = "v1/threads"
    let body: Data?

    init(
        messages: [Thread.Message],
        metadata: [String : String]?
    ) throws {
        let body = Body(
            messages: messages,
            metadata: metadata
        )

        self.body = try Self.encoder.encode(body)
    }
}

extension CreateThreadRequest {
    struct Body: Encodable {
        let messages: [Thread.Message]
        let metadata: [String : String]?
    }
}
