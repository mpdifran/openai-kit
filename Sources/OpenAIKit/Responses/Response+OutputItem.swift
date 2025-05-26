//
//  Response+OutputItem.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-05-20.
//

import Foundation

public extension Response {
  enum OutputItem: Codable, Hashable, Sendable {
    case message(OutputMessage)
    case functionToolCall(FunctionToolCall)
    case webSearchToolCall(WebSearchToolCall)
    case reasoning(Reasoning)

    public init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      if let value = try? container.decode(OutputMessage.self) {
        self = .message(value)
        return
      }
      if let value = try? container.decode(FunctionToolCall.self) {
        self = .functionToolCall(value)
        return
      }
      if let value = try? container.decode(WebSearchToolCall.self) {
        self = .webSearchToolCall(value)
        return
      }
      if let value = try? container.decode(Reasoning.self) {
        self = .reasoning(value)
        return
      }
      throw DecodingError.typeMismatch(
        OutputItem.self,
        DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown OutputItem type")
      )
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.singleValueContainer()
      switch self {
      case .message(let value):
        try container.encode(value)
      case .functionToolCall(let value):
        try container.encode(value)
      case .webSearchToolCall(let value):
        try container.encode(value)
      case .reasoning(let value):
        try container.encode(value)
      }
    }
  }
}

public extension Response.OutputItem {
  struct OutputMessage: Codable, Hashable, Sendable {
    public let type: `Type`
    public let id: String
    public let role: Role
    public let status: Response.Status
    public let content: [Content]

    public init(
      type: Type,
      id: String,
      role: Role,
      status: Response.Status,
      content: [Content]
    ) {
      self.type = type
      self.id = id
      self.role = role
      self.status = status
      self.content = content
    }
  }
}

public extension Response.OutputItem.OutputMessage {
  enum `Type`: String, Codable, Hashable, Sendable {
    case message
  }

  enum Role: String, Codable, Hashable, Sendable {
    case assistant
  }

  enum Content: Codable, Hashable, Sendable {
    case outputText(Response.OutputText)
    case refusal(Response.Refusal)

    public init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      if let value = try? container.decode(Response.OutputText.self) {
        self = .outputText(value)
        return
      }
      if let value = try? container.decode(Response.Refusal.self) {
        self = .refusal(value)
        return
      }
      throw DecodingError.typeMismatch(
        Content.self,
        DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown Content type")
      )
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.singleValueContainer()
      switch self {
      case .outputText(let value):
        try container.encode(value)
      case .refusal(let value):
        try container.encode(value)
      }
    }
  }
}

public extension Response {
  enum ContentPart: Codable, Hashable, Sendable {
    case outputText(Response.OutputText)
    case refusal(Response.Refusal)

    public init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      if let value = try? container.decode(Response.OutputText.self) {
        self = .outputText(value)
        return
      }
      if let value = try? container.decode(Response.Refusal.self) {
        self = .refusal(value)
        return
      }
      throw DecodingError.typeMismatch(
        ContentPart.self,
        DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown ContentPart type")
      )
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.singleValueContainer()
      switch self {
      case .outputText(let value):
        try container.encode(value)
      case .refusal(let value):
        try container.encode(value)
      }
    }
  }
}

public extension Response {

  struct OutputText: Codable, Hashable, Sendable {
    public let type: `Type`
    public let text: String
    public let annotations: [Annotation]

    public enum `Type`: String, Codable, Hashable, Sendable {
      case outputText = "output_text"
    }

    public init(
      type: `Type`,
      text: String,
      annotations: [Annotation]
    ) {
      self.type = type
      self.text = text
      self.annotations = annotations
    }
  }

  struct Refusal: Codable, Hashable, Sendable {
    public let type: `Type`
    public let refusal: String

    public enum `Type`: String, Codable, Hashable, Sendable {
      case refusal = "refusal"
    }

    public init(type: `Type`, refusal: String) {
      self.type = type
      self.refusal = refusal
    }
  }
}

public extension Response.OutputItem {
  struct FunctionToolCall: Codable, Hashable, Sendable {
    public let type: `Type`
    public let id: String
    public let name: String
    public let arguments: String
    public let callId: String
    public let status: Response.Status?

    public init(
      type: `Type`,
      id: String,
      name: String,
      arguments: String,
      callId: String,
      status: Response.Status? = nil
    ) {
      self.type = type
      self.id = id
      self.name = name
      self.arguments = arguments
      self.callId = callId
      self.status = status
    }
  }
}

public extension Response.OutputItem.FunctionToolCall {
  enum `Type`: String, Codable, Hashable, Sendable {
    case functionCall = "function_call"
  }
}

public extension Response.OutputItem {
  struct WebSearchToolCall: Codable, Hashable, Sendable {
    public let type: `Type`
    public let id: String
    public let status: String

    public enum `Type`: String, Codable, Hashable, Sendable {
      case webSearchCall = "web_search_call"
    }

    public init(type: `Type`, id: String, status: String) {
      self.type = type
      self.id = id
      self.status = status
    }
  }
}

public extension Response.OutputItem {
  struct Reasoning: Codable, Hashable, Sendable {
    public let type: `Type`
    public let id: String
    public let summary: [SummaryText]
    public let encryptedContent: String?
    public let status: Response.Status?

    public enum `Type`: String, Codable, Hashable, Sendable {
      case reasoning = "reasoning"
    }
  }
}

public extension Response.OutputItem.Reasoning {
  struct SummaryText: Codable, Hashable, Sendable {
    public let type: `Type`
    public let text: String

    public enum `Type`: String, Codable, Hashable, Sendable {
      case summaryText = "summary_text"
    }

    public init(type: Type, text: String) {
      self.type = type
      self.text = text
    }
  }
}

public extension Response {
  enum Annotation: Hashable, Sendable, Codable {
    case fileCitation(FileCitation)
    case urlCitation(URLCitation)
    case filePath(FilePath)

    public init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      if let citation = try? container.decode(URLCitation.self) {
        self = .urlCitation(citation)
        return
      }
      if let citation = try? container.decode(FileCitation.self) {
        self = .fileCitation(citation)
      }
      if let citation = try? container.decode(FilePath.self) {
        self = .filePath(citation)
        return
      }
      throw DecodingError.typeMismatch(
        Annotation.self,
        DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown Annotation type")
      )
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.singleValueContainer()
      switch self {
      case .fileCitation(let citation):
        try container.encode(citation)
      case .urlCitation(let citation):
        try container.encode(citation)
      case .filePath(let citation):
        try container.encode(citation)
      }
    }
  }
}

public extension Response.Annotation {
  struct URLCitation: Codable, Hashable, Sendable {
    public let type: `Type`
    public let title: String
    public let url: URL
    public let startIndex: Int
    public let endIndex: Int

    public enum `Type`: String, Codable, Hashable, Sendable {
      case urlCitation = "url_citation"
    }
  }

  struct FileCitation: Codable, Hashable, Sendable {
    public let type: `Type`
    public let fileId: String
    public let index: Int

    public enum `Type`: String, Codable, Hashable, Sendable {
      case fileCitation = "file_citation"
    }
  }

  struct FilePath: Codable, Hashable, Sendable {
    public let type: `Type`
    public let fileId: String
    public let index: Int

    public enum `Type`: String, Codable, Hashable, Sendable {
      case filePath = "file_path"
    }
  }
}
