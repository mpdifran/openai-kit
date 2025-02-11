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

extension Thread.Message {
    private enum CodingKeys: String, CodingKey {
        case role
        case content
    }

    private enum ContentKeys: String, CodingKey {
        case type
        case text
        case imageURL = "image_url"
        case imageFile = "image_file"
    }

    private enum ImageURLKeys: String, CodingKey {
        case url
        case detail
    }

    private enum ImageFileKeys: String, CodingKey {
        case fileID = "file_id"
        case detail
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        role = try container.decode(Thread.Message.Role.self, forKey: .role)

        if let singleTextContent = try? container.decode(String.self, forKey: .content) {
            content = [.text(singleTextContent)]
        } else {
            var contentsArray = try container.nestedUnkeyedContainer(forKey: .content)
            var contents = [Content]()

            while !contentsArray.isAtEnd {
                let contentContainer = try contentsArray.nestedContainer(keyedBy: ContentKeys.self)
                let type = try contentContainer.decode(String.self, forKey: .type)

                switch type {
                case "text":
                    let text = try contentContainer.decode(String.self, forKey: .text)
                    contents.append(.text(text))
                case "image_url":
                    let imageURLContainer = try contentContainer.nestedContainer(keyedBy: ImageURLKeys.self, forKey: .imageURL)

                    if let url = try? imageURLContainer.decode(URL.self, forKey: .url) {
                        let detail = try imageURLContainer.decodeIfPresent(ImageDetail.self, forKey: .detail) ?? .auto

                        contents.append(.imageURL(url, detail))
                    } else {
                        throw DecodingError.dataCorruptedError(forKey: .type, in: contentContainer, debugDescription: "Unknown image URL")
                    }
                case "image_file":
                    let imageFileContainer = try contentContainer.nestedContainer(keyedBy: ImageFileKeys.self, forKey: .imageFile)

                    if let fileID = try? imageFileContainer.decode(String.self, forKey: .fileID) {
                        let detail = try imageFileContainer.decodeIfPresent(ImageDetail.self, forKey: .detail) ?? .auto

                        contents.append(.imageFile(fileID, detail))
                    } else {
                        throw DecodingError.dataCorruptedError(forKey: .type, in: contentContainer, debugDescription: "Unknown image file ID")
                    }
                default:
                    throw DecodingError.dataCorruptedError(forKey: .type, in: contentContainer, debugDescription: "Unknown content type: \(type)")
                }
            }
            content = contents
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(role, forKey: .role)

        if content.count == 1, let text = content.first?.text {
            try container.encode(text, forKey: .content)
        } else {
            var contentsArray = container.nestedUnkeyedContainer(forKey: .content)
            for contentItem in content {
                var contentContainer = contentsArray.nestedContainer(keyedBy: ContentKeys.self)
                switch contentItem {
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
                    try imageFileContainer.encode(fileID, forKey: .fileID)
                    try imageFileContainer.encode(detail, forKey: .detail)
                }
            }
        }
    }
}
