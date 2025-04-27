//
//  ToolOutput.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-02-11.
//

import Foundation

public struct ToolOutput: Codable {
    public let toolCallID: String
    public let output: String?

    public init(
        toolCallID: String,
        output: String?
    ) {
        self.toolCallID = toolCallID
        self.output = output
    }

    private enum CodingKeys: String, CodingKey {
        case toolCallID
        case output
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(toolCallID, forKey: .toolCallID)
        if let output = output {
            try container.encode(output, forKey: .output)
        } else {
            // Encode an empty object when output is nil
            let emptyObject: [String: String] = [:]
            try container.encode(emptyObject, forKey: .output)
        }
    }
}
