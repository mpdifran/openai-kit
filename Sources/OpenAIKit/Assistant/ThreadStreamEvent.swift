//
//  ThreadStreamEvent.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-04-23.
//

import Foundation

/// A top‑level event wrapper that decodes different thread API events over stream.
public enum ThreadStreamEvent: Decodable {
    case message(Thread.Message)
    case messageDelta(Thread.Message.Delta)
    case run(Run)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let object = try container.decode(String.self, forKey: .object)

        if object == "thread.message" {
            let message = try Thread.Message(from: decoder)
            self = .message(message)
        } else if object == "thread.message.delta" {
            let delta = try Thread.Message.Delta(from: decoder)
            self = .messageDelta(delta)
        } else if object == "thread.run" {
            let run = try Run(from: decoder)
            self = .run(run)
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .object,
                in: container,
                debugDescription: "Unrecognized object type: \(object)"
            )
        }
    }

    private enum CodingKeys: String, CodingKey {
        case object
    }
}
