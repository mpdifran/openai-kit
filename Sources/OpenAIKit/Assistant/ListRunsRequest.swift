//
//  ListRunsRequest.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-02-22.
//

import AsyncHTTPClient
import NIOHTTP1
import Foundation

struct ListRunsRequest: Request {
  let headers: HTTPHeaders = ["OpenAI-Beta" : "assistants=v2"]
  let method: HTTPMethod = .GET
  let path: String

  init(
    threadID: String
  ) {
    self.path = "/threads/\(threadID)/runs"
  }
}
