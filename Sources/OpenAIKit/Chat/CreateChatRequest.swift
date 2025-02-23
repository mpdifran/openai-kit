import AsyncHTTPClient
import NIOHTTP1
import Foundation

struct CreateChatRequest: Request {
    let method: HTTPMethod = .POST
    let path = "/chat/completions"
    let body: Data?
    
    init(
        model: String,
        messages: [Chat.Message],
        temperature: Double?,
        topP: Double?,
        n: Int?,
        stream: Bool?,
        stops: [String]?,
        maxCompletionTokens: Int?,
        presencePenalty: Double?,
        frequencyPenalty: Double?,
        logitBias: [String: Int]?,
        user: String?,
        responseFormat: ResponseFormat?
    ) throws {
        
        let body = Body(
            model: model,
            messages: messages,
            temperature: temperature,
            topP: topP,
            n: n,
            stream: stream,
            stops: stops,
            maxCompletionTokens: maxCompletionTokens,
            presencePenalty: presencePenalty,
            frequencyPenalty: frequencyPenalty,
            logitBias: logitBias,
            user: user,
            responseFormat: responseFormat
        )
                
        self.body = try Self.encoder.encode(body)
    }
}

extension CreateChatRequest {
    struct Body: Encodable {
        let model: String
        let messages: [Chat.Message]
        let temperature: Double?
        let topP: Double?
        let n: Int?
        let stream: Bool?
        let stops: [String]?
        let maxCompletionTokens: Int?
        let presencePenalty: Double?
        let frequencyPenalty: Double?
        let logitBias: [String: Int]?
        let user: String?
        let responseFormat: ResponseFormat?
    }
}
