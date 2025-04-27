//
//  ToolOutput.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-02-11.
//

import Foundation

public struct ToolOutput: Codable {
    public let toolCallID: String
    public let output: String

    public init(
        toolCallID: String,
        output: String
    ) {
        self.toolCallID = toolCallID
        self.output = output
    }
}
