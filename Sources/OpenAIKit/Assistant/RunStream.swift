//
//  RunStream.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-04-23.
//

import Foundation

struct RunStreamChunk: Decodable, Sendable {
    let choices: [Choice]
}

extension RunStreamChunk {
    struct Choice: Codable {
        let delta: Delta
    }
}

extension RunStreamChunk.Choice {
    struct Delta: Codable {
        let content: String?
    }
}
