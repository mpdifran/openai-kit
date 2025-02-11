//
//  AssistantProvider.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-02-10.
//

public struct AssistantProvider {

    private let requestHandler: RequestHandler

    init(requestHandler: RequestHandler) {
        self.requestHandler = requestHandler
    }

    /**
    Create an assistant.
     POST

     https://api.openai.com/v1/assistants

     Create an assistant with a model and instructions.
     */
    public func createAssistant(
        model: ModelID,
        name: String? = nil,
        instructions: String? = nil,
        reasoningEffort: Assistant.ReasoningEffort? = nil,
        tools: [Assistant.Tool]? = nil,
        metadata: [String : String]? = nil,
        temperature: Double? = nil,
        topP: Double? = nil,
        responseFormat: ResponseFormat = ResponseFormat(type: .auto)
    ) async throws -> Assistant {

        let request = try CreateAssistantRequest(
            model: model.id,
            name: name,
            instructions: instructions,
            reasoningEffort: reasoningEffort,
            tools: tools,
            metadata: metadata,
            temperature: temperature,
            topP: topP,
            responseFormat: responseFormat
        )

        return try await requestHandler.perform(request: request)
    }

    /**
     Create a thread.
     POST

     https://api.openai.com/v1/threads

     Create a thread.
     */
    public func createThread(
        messages: [Thread.Message],
        metadata: [String : String]? = nil
    ) async throws -> Thread {

        let request = try CreateThreadRequest(
            messages: messages,
            metadata: metadata
        )

        return try await requestHandler.perform(request: request)
    }
}
