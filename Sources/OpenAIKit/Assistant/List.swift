//
//  List.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-02-13.
//

import Foundation

public struct List<Content: Codable>: Codable {
    public let data: [Content]
}
