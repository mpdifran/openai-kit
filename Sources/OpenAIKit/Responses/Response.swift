//
//  Response.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-05-18.
//

import Foundation

public struct Response: Codable, Hashable, Sendable {
    public let id: String
    public let instructions: String
    public let model: String
    public let status: Status
    public let user: String?
}

public extension Response {
    enum Status: String, Codable, Hashable, Sendable {
        case complete
        case failed
        case inProgress = "in_progress"
        case incomplete
    }
}

public extension Response {
    struct Reasoning: Encodable {
        public let effort: ReasoningEffort?
        public let summary: Summary?

        public init(
            effort: ReasoningEffort?,
            summary: Summary?
        ) {
            self.effort = effort
            self.summary = summary
        }
    }

    enum ReasoningEffort: String, Encodable {
        case low
        case medium
        case high
    }

    enum Summary: String, Encodable {
        case auto
        case concise
        case detailed
    }
}

public extension Response {
    enum Tool: Codable, Hashable, Sendable {
        case function(Function)
        case webSearchPreview(WebSearchPreview)

        public func encode(to encoder: any Encoder) throws {
            switch self {
            case .function(let function):
                try function.encode(to: encoder)
            case .webSearchPreview(let webSearchPreview):
                try webSearchPreview.encode(to: encoder)
            }
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(String.self, forKey: .type)

            switch type {
            case "function":
                self = .function(try Function(from: decoder))
            case "web_search_preview", "web_search_preview_2025_03_11":
                self = .webSearchPreview(try WebSearchPreview(from: decoder))
            default:
                throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Invalid tool type.")
            }
        }

        private enum CodingKeys: String, CodingKey {
            case type
        }
    }
}

public extension Response.Tool {
    struct WebSearchPreview: Codable, Hashable, Sendable {
        public let type: `Type`
        public let searchContextSize: ContextSize?
        public let userLocation: UserLocation?

        public init(
            type: `Type`,
            searchContextSize: ContextSize? = nil,
            userLocation: UserLocation? = nil
        ) {
            self.type = type
            self.searchContextSize = searchContextSize
            self.userLocation = userLocation
        }
    }
}

public extension Response.Tool.WebSearchPreview {
    enum `Type`: String, Codable, Hashable, Sendable {
        case standard = "web_search_preview"
        case march11 = "web_search_preview_2025_03_11"
    }

    enum ContextSize: String, Codable, Hashable, Sendable {
        case low
        case medium
        case high
    }

    struct UserLocation: Codable, Hashable, Sendable {
        public let type: `Type`
        public let city: String?
        public let country: String?
        public let region: String?
        public let timezone: String?

        public init(
            city: String? = nil,
            country: String? = nil,
            region: String? = nil,
            timezone: String? = nil
        ) {
            self.type = .approximate
            self.city = city
            self.country = country
            self.region = region
            self.timezone = timezone
        }
    }
}

public extension Response.Tool.WebSearchPreview.UserLocation {
    enum `Type`: String, Codable, Hashable, Sendable {
        case approximate
    }
}
