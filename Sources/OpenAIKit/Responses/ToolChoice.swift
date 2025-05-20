//
//  ToolChoice.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-05-18.
//

public extension Response {
    enum ToolChoice: Codable {
        case none
        case auto
        case required
        case hosted(HostedTool)
        case function(String)
    }
}

public extension Response {
    enum HostedTool: String, Codable {
        case fileSearch = "file_search"
        case webSearchPreview = "web_search_preview"
        case computerUsePreview = "computer_use_preview"
    }
}

extension Response.ToolChoice {

    private enum CodingKeys: String, CodingKey {
        case type
        case name
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .none:
            try container.encode("none")
        case .auto:
            try container.encode("auto")
        case .required:
            try container.encode("required")
        case .hosted(let hostedTool):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(hostedTool, forKey: .type)
        case .function(let functionName):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode("function", forKey: .type)
            try container.encode(functionName, forKey: .name)
        }
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let stringValue = try? container.decode(String.self) {
            switch stringValue {
            case "none":
                self = .none
            case "auto":
                self = .auto
            case "required":
                self = .required
            default:
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Unexpected string value for ToolChoice: \(stringValue)"
                )
            }
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(String.self, forKey: .type)
        
            if let hostedTool = Response.HostedTool(rawValue: type) {
                self = .hosted(hostedTool)
            } else if type == "function" {
                let functionName = try container.decode(String.self, forKey: .name)
                self = .function(functionName)
            } else {
                throw DecodingError.dataCorruptedError(
                    forKey: .type,
                    in: container,
                    debugDescription: "Unexpected type for ToolChoice: \(type)"
                )
            }
        }
    }
}
