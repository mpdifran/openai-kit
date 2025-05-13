//
//  Thread.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-02-10.
//

import Foundation

public struct Thread: Codable {
    public let id: String
    public let metadata: [String : String]
}

public extension Thread {
    struct Message: Codable {
        public let role: Role
        public let content: [Content]

        public init(
            role: Role,
            content: [Content]
        ) {
            self.role = role
            self.content = content
        }
    }
}

public extension Thread.Message {
    enum Role: String, Codable {
        case user
        case assistant
    }

    enum Content: Codable {
        /// Text content.
        case text(String)
        /// A URL to an image.
        case imageURL(URL, ImageDetail)
        /// A file ID for an image.
        case imageFile(String, ImageDetail)
    }

    enum ImageDetail: String, Codable {
        case low
        case high
        case auto
    }
}

extension Thread.Message.Content {
    public var text: String? {
        switch self {
        case .text(let text):
            return text
        default:
            return nil
        }
    }
    public var imageURL: URL? {
        switch self {
        case .imageURL(let url, _):
            return url
        default:
            return nil
        }
    }
    public var imageFileID: String? {
        switch self {
        case .imageFile(let fileID, _):
            return fileID
        default:
            return nil
        }
    }
}

extension Thread.Message.Content {

    private enum ContentKeys: String, CodingKey {
        case type
        case text
        case imageURL
        case imageFile
    }

    private enum ImageURLKeys: String, CodingKey {
        case url
        case detail
    }

    private enum ImageFileKeys: String, CodingKey {
        case fileId
        case detail
    }

    public init(from decoder: any Decoder) throws {
        let contentContainer = try decoder.container(keyedBy: ContentKeys.self)
        let type = try contentContainer.decode(String.self, forKey: .type)

        switch type {
        case "text":
            let text = try contentContainer.decode(String.self, forKey: .text)
            self = .text(text)
        case "image_url":
            let imageURLContainer = try contentContainer.nestedContainer(keyedBy: ImageURLKeys.self, forKey: .imageURL)

            if let url = try? imageURLContainer.decode(URL.self, forKey: .url) {
                let detail = try imageURLContainer.decodeIfPresent(Thread.Message.ImageDetail.self, forKey: .detail) ?? .auto

                self = .imageURL(url, detail)
            } else {
                throw DecodingError.dataCorruptedError(forKey: .type, in: contentContainer, debugDescription: "Unknown image URL")
            }
        case "image_file":
            let imageFileContainer = try contentContainer.nestedContainer(keyedBy: ImageFileKeys.self, forKey: .imageFile)

            if let fileID = try? imageFileContainer.decode(String.self, forKey: .fileId) {
                let detail = try imageFileContainer.decodeIfPresent(Thread.Message.ImageDetail.self, forKey: .detail) ?? .auto

                self = .imageFile(fileID, detail)
            } else {
                throw DecodingError.dataCorruptedError(forKey: .type, in: contentContainer, debugDescription: "Unknown image file ID")
            }
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: contentContainer, debugDescription: "Unknown content type: \(type)")
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var contentContainer = encoder.container(keyedBy: ContentKeys.self)
        switch self {
        case .text(let text):
            try contentContainer.encode("text", forKey: .type)
            try contentContainer.encode(text, forKey: .text)
        case .imageURL(let url, let detail):
            try contentContainer.encode("image_url", forKey: .type)
            var urlContainer = contentContainer.nestedContainer(keyedBy: ImageURLKeys.self, forKey: .imageURL)
            try urlContainer.encode(url, forKey: .url)
            try urlContainer.encode(detail, forKey: .detail)
        case .imageFile(let fileID, let detail):
            try contentContainer.encode("image_file", forKey: .type)
            var imageFileContainer = contentContainer.nestedContainer(keyedBy: ImageFileKeys.self, forKey: .imageFile)
            try imageFileContainer.encode(fileID, forKey: .fileId)
            try imageFileContainer.encode(detail, forKey: .detail)
        }
    }
}

public extension Thread.Message {
    struct Delta: Codable {
        public let id: String
        public let delta: DeltaContentList
    }
}

public extension Thread.Message.Delta {
    struct DeltaContentList: Codable {
        public let content: [DeltaContent]
    }
}

public extension Thread.Message.Delta {
    struct DeltaContent: Codable {
        public let index: Int
        public let text: Text
    }
}

public extension Thread.Message.Delta.DeltaContent {
    struct Text: Codable {
        public let value: String
    }
}
