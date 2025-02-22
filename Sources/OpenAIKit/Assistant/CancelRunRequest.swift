//
//  CancelRunRequest.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-02-22.
//

import AsyncHTTPClient
import NIOHTTP1
import Foundation

struct CancelRunRequest: Request {
  let headers: HTTPHeaders = ["OpenAI-Beta" : "assistants=v2"]
  let method: HTTPMethod = .POST
  let path: String

  init(
    threadID: String,
    runID: String
  ) {
    self.path = "/v1/threads/\(threadID)/runs/\(runID)/cancel"
  }
}
