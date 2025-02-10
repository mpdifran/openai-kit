//
//  Content.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-02-10.
//

public extension ResponseFormat {
    enum `Type`: String, Codable {
        case json = "json_object"
    }
}

public struct ResponseFormat: Codable {
    public let type: `Type`

    public init(type: Type) {
        self.type = type
    }
}
