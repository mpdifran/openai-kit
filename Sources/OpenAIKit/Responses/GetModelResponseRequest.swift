//
//  GetModelResponseRequest.swift
//  openai-kit
//
//  Created by Assistant on 2025-06-11.
//

import AsyncHTTPClient
import NIOHTTP1
import Foundation

struct GetModelResponseRequest: Request {
    let method: HTTPMethod = .GET
    let path: String
    
    init(responseID: String) {
        self.path = "/responses/\(responseID)"
    }
}