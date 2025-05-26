//
//  ListInputItemsRequest.swift
//  openai-kit
//
//  Created by Assistant on 2025-05-26.
//

import Foundation
import AsyncHTTPClient
import NIOHTTP1

struct ListInputItemsRequest: Request {
    let method: HTTPMethod = .GET
    let path: String
    
    init(responseID: String) {
        self.path = "/responses/\(responseID)/input_items"
    }
}