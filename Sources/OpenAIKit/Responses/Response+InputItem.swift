//
//  Response+InputItem.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-05-20.
//

import Foundation

// MARK: - Input Item

public extension Response {
  enum InputItem: Codable, Hashable, Sendable {
    case message(InputMessage)
    case item(Item)
    case itemReference(ItemReference)

    public init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      if let message = try? container.decode(InputMessage.self) {
        self = .message(message)
      } else if let item = try? container.decode(Item.self) {
        self = .item(item)
      } else if let ref = try? container.decode(ItemReference.self) {
        self = .itemReference(ref)
      } else {
        throw DecodingError.typeMismatch(
          Response.InputItem.self,
          DecodingError.Context(
            codingPath: decoder.codingPath,
            debugDescription: "Cannot decode InputItem"
          )
        )
      }
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.singleValueContainer()
      switch self {
      case .message(let message):
        try container.encode(message)
      case .item(let item):
        try container.encode(item)
      case .itemReference(let ref):
        try container.encode(ref)
      }
    }
  }
}

// MARK: - Input Message

public extension Response.InputItem {
  struct InputMessage: Codable, Hashable, Sendable {
    public let type: `Type`
    public let role: Role
    public let content: [Content]
    public let status: Response.Status?

    public init(
      role: Role,
      content: [Content],
      status: Response.Status? = nil
    ) {
      self.type = .message
      self.role = role
      self.content = content
      self.status = status
    }
  }
}

public extension Response.InputItem.InputMessage {
  enum `Type`: String, Codable, Hashable, Sendable {
    case message
  }

  enum Role: String, Codable, Hashable, Sendable {
    case assistant
    case user
    case system
    case developer
  }
}

public extension Response.InputItem {
  enum Content: Codable, Hashable, Sendable {
    case text(InputText)
    case image(InputImage)
    case file(InputFile)
    case audio(InputAudio)

    public init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      if let text = try? container.decode(InputText.self) {
        self = .text(text)
      } else if let image = try? container.decode(InputImage.self) {
        self = .image(image)
      } else if let file = try? container.decode(InputFile.self) {
        self = .file(file)
      } else if let audio = try? container.decode(InputAudio.self) {
        self = .audio(audio)
      } else {
        throw DecodingError.typeMismatch(
          Response.InputItem.self,
          DecodingError.Context(
            codingPath: decoder.codingPath,
            debugDescription: "Cannot decode InputItemContent"
          )
        )
      }
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.singleValueContainer()
      switch self {
      case .text(let text):
        try container.encode(text)
      case .image(let image):
        try container.encode(image)
      case .file(let file):
        try container.encode(file)
      case .audio(let audio):
        try container.encode(audio)
      }
    }
  }

  struct InputText: Codable, Hashable, Sendable {
    public let type: `Type`
    public let text: String

    public init(text: String) {
      self.type = .inputText
      self.text = text
    }
  }

  struct InputImage: Codable, Hashable, Sendable {
    public let type: `Type`
    public let detail: Detail
    public let fileId: String?
    public let imageUrl: URL?

    public init(detail: Detail, fileId: String? = nil) {
      self.type = .inputImage
      self.detail = detail
      self.fileId = fileId
      self.imageUrl = nil
    }

    public init(detail: Detail, imageUrl: URL? = nil) {
      self.type = .inputImage
      self.detail = detail
      self.fileId = nil
      self.imageUrl = imageUrl
    }
  }

  struct InputFile: Codable, Hashable, Sendable {
    public let type: `Type`
    public let fileId: String?
    public let fileData: String?
    public let filename: String?

    public init(
      fileId: String?,
      fileData: String?,
      filename: String?
    ) {
      self.type = .inputFile
      self.fileId = fileId
      self.fileData = fileData
      self.filename = filename
    }
  }

  struct InputAudio: Codable, Hashable, Sendable {
    public let type: `Type`
    public let fileId: String?
    public let audioData: String?

    public enum `Type`: String, Codable, Hashable, Sendable {
      case inputAudio = "input_audio"
    }

    public init(
      fileId: String? = nil,
      audioData: String? = nil
    ) {
      self.type = .inputAudio
      self.fileId = fileId
      self.audioData = audioData
    }
  }
}

public extension Response.InputItem.InputText {
  enum `Type`: String, Codable, Hashable, Sendable {
    case inputText = "input_text"
  }
}

public extension Response.InputItem.InputImage {
  enum `Type`: String, Codable, Hashable, Sendable {
    case inputImage = "input_image"
  }

  enum Detail: String, Codable, Hashable, Sendable {
    case auto
    case low
    case high
  }
}

public extension Response.InputItem.InputFile {
  enum `Type`: String, Codable, Hashable, Sendable {
    case inputFile = "input_file"
  }
}

// MARK: - Item

public extension Response.InputItem {
  enum Item: Codable, Hashable, Sendable {
    case inputMessage(InputMessage)
    case outputMessage(Response.OutputItem.OutputMessage)
    case webSearchToolCall(Response.OutputItem.WebSearchToolCall)
    case functionToolCall(Response.OutputItem.FunctionToolCall)
    case functionToolCallOutput(Response.InputItem.FunctionToolCallOutput)
    case webSearchToolCallOutput(Response.InputItem.WebSearchToolCallOutput)
    case reasoning(Response.OutputItem.Reasoning)

    public init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      if let inputMsg = try? container.decode(Response.InputItem.InputMessage.self) {
        self = .inputMessage(inputMsg)
      } else if let outputMsg = try? container.decode(Response.OutputItem.OutputMessage.self) {
        self = .outputMessage(outputMsg)
      } else if let webCall = try? container.decode(Response.OutputItem.WebSearchToolCall.self) {
        self = .webSearchToolCall(webCall)
      } else if let funcCall = try? container.decode(Response.OutputItem.FunctionToolCall.self) {
        self = .functionToolCall(funcCall)
      } else if let funcOutput = try? container.decode(Response.InputItem.FunctionToolCallOutput.self) {
        self = .functionToolCallOutput(funcOutput)
      } else if let webOutput = try? container.decode(Response.InputItem.WebSearchToolCallOutput.self) {
        self = .webSearchToolCallOutput(webOutput)
      } else if let reasoning = try? container.decode(Response.OutputItem.Reasoning.self) {
        self = .reasoning(reasoning)
      } else {
        throw DecodingError.typeMismatch(
          Response.InputItem.Item.self,
          DecodingError.Context(
            codingPath: decoder.codingPath,
            debugDescription: "Cannot decode Response.InputItem.Item"
          )
        )
      }
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.singleValueContainer()
      switch self {
      case .inputMessage(let msg):
        try container.encode(msg)
      case .outputMessage(let msg):
        try container.encode(msg)
      case .webSearchToolCall(let call):
        try container.encode(call)
      case .functionToolCall(let call):
        try container.encode(call)
      case .functionToolCallOutput(let output):
        try container.encode(output)
      case .webSearchToolCallOutput(let output):
        try container.encode(output)
      case .reasoning(let reasoning):
        try container.encode(reasoning)
      }
    }
  }
}

// MARK: - Item Reference

public extension Response.InputItem {
  struct ItemReference: Codable, Hashable, Sendable {
    public let type: `Type`
    public let id: String

    public init(id: String) {
      self.type = .itemReference
      self.id = id
    }
  }
}

public extension Response.InputItem.ItemReference {
  enum `Type`: String, Codable, Hashable, Sendable {
    case itemReference = "item_reference"
  }
}

// MARK: - Function Tool Call Output

public extension Response.InputItem {
  struct FunctionToolCallOutput: Codable, Hashable, Sendable {
    public let type: `Type`
    public let callId: String
    public let output: String
    public let id: String?
    public let status: Response.Status?

    public init(
      callId: String,
      output: String,
      id: String? = nil,
      status: Response.Status? = nil
    ) {
      self.type = .functionToolCallOutput
      self.callId = callId
      self.output = output
      self.id = id
      self.status = status
    }
  }
}

public extension Response.InputItem.FunctionToolCallOutput {
  enum `Type`: String, Codable, Hashable, Sendable {
    case functionToolCallOutput = "function_call_output"
  }
}

// MARK: - Web Search Tool Call Output

public extension Response.InputItem {
  struct WebSearchToolCallOutput: Codable, Hashable, Sendable {
    public let type: `Type`
    public let callId: String
    public let output: String
    public let id: String?
    public let status: Response.Status?

    public enum `Type`: String, Codable, Hashable, Sendable {
      case webSearchToolCallOutput = "web_search_call_output"
    }

    public init(
      callId: String,
      output: String,
      id: String? = nil,
      status: Response.Status? = nil
    ) {
      self.type = .webSearchToolCallOutput
      self.callId = callId
      self.output = output
      self.id = id
      self.status = status
    }
  }
}
