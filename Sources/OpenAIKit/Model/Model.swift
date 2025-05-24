import Foundation

/**
 List and describe the various models available in the API.
 */
public struct Model: Codable, Hashable, Sendable {
    public let id: String
    public let object: String
    public let created: Date
    public let ownedBy: String
    public let permission: [Permission]?
    public let root: String?
    public let parent: String?
}

extension Model {
    public struct Permission: Codable, Hashable, Sendable {
        public let id: String
        public let object: String
        public let created: Date
        public let allowCreateEngine: Bool
        public let allowSampling: Bool
        public let allowLogprobs: Bool
        public let allowSearchIndices: Bool
        public let allowView: Bool
        public let allowFineTuning: Bool
        public let organization: String
        public let group: String?
        public let isBlocking: Bool
    }
}

public struct ModelID: Codable, Hashable, Sendable {
    public let id: String
}

extension ModelID {
    public enum OSeries {
        public static let o1 = ModelID(id: "o1")
        public static let o1Preview = ModelID(id: "o1-preview")
        public static let o1Mini = ModelID(id: "o1-mini")
        public static let o1Pro = ModelID(id: "o1-pro")
        public static let o3Mini = ModelID(id: "o3-mini")
        public static let o4Mini = ModelID(id: "o4-mini")
    }

    public enum GPT4 {
        public static let gpt4 = ModelID(id: "gpt-4")
        public static let gpt4Turbo = ModelID(id: "gpt-4-turbo")
        public static let gpt40314 = ModelID(id: "gpt-4-0314")
        public static let gpt4_32k = ModelID(id: "gpt-4-32k")
        public static let gpt4_32k0314 = ModelID(id: "gpt-4-32k-0314")
        public static let gpt4_1Nano = ModelID(id: "gpt-4.1-nano")
        public static let gpt_4o = ModelID(id: "gpt-4o")
        public static let gpt_4o_0513 = ModelID(id: "gpt-4o-2024-05-13")
        public static let gpt_4o_mini = ModelID(id: "gpt-4o-mini")
        public static let gpt_4o_mini_0718 = ModelID(id: "gpt-4o-mini-2024-07-18")
        public static let gpt4_1 = ModelID(id: "gpt-4.1")
        public static let gpt4_1Mini = ModelID(id: "gpt-4.1-mini")
    }

    public enum GPT3 {
        public static let gpt3_5Turbo = ModelID(id: "gpt-3.5-turbo")
        public static let gpt3_5Turbo16K = ModelID(id: "gpt-3.5-turbo-16k")
        public static let gpt3_5Turbo0301 = ModelID(id: "gpt-3.5-turbo-0301")
        public static let textDavinci003 = ModelID(id: "text-davinci-003")
        public static let textDavinci002 = ModelID(id: "text-davinci-002")
        public static let textCurie001 = ModelID(id: "text-curie-001")
        public static let textBabbage001 = ModelID(id: "text-babbage-001")
        public static let textAda001 = ModelID(id: "text-ada-001")
        public static let textEmbeddingAda002 = ModelID(id: "text-embedding-ada-002")
        public static let textDavinci001 = ModelID(id: "text-davinci-001")
        public static let textDavinciEdit001 = ModelID(id: "text-davinci-edit-001")
        public static let davinciInstructBeta = ModelID(id: "davinci-instruct-beta")
        public static let davinci = ModelID(id: "davinci")
        public static let curieInstructBeta = ModelID(id: "curie-instruct-beta")
        public static let curie = ModelID(id: "curie")
        public static let ada = ModelID(id: "ada")
        public static let babbage = ModelID(id: "babbage")
    }

    public enum Codex {
        public static let codeDavinci002 = ModelID(id: "code-davinci-002")
        public static let codeCushman001 = ModelID(id: "code-cushman-001")
        public static let codeDavinci001 = ModelID(id: "code-davinci-001")
        public static let codeDavinciEdit001 = ModelID(id: "code-davinci-edit-001")
    }

    public enum Whisper {
        public static let whisper1 = ModelID(id: "whisper-1")
    }

    public enum Gemini {
        public static let flash2_0 = ModelID(id: "gemini-2.0-flash")
        public static let flash1_5 = ModelID(id: "gemini-1.5-flash")
        public static let pro1_5 = ModelID(id: "gemini-1.5-pro")
    }
}

extension RawRepresentable where RawValue == String {
    public var id: String {
        rawValue
    }
}
