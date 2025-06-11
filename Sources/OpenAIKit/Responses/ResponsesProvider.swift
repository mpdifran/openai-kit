//
//  ResponsesProvider.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-05-18.
//

import Foundation

public struct ResponsesProvider: Sendable {

    private let requestHandler: RequestHandler

    init(requestHandler: RequestHandler) {
        self.requestHandler = requestHandler
    }
    
    /**
     Create a model response.
     POST


     https://api.openai.com/v1/responses

     Creates a model response. Provide text or image inputs to generate text or JSON outputs. Have the model call your own custom code or use built-in tools like web search or file search to use your own data as input for the model's response.
     */
    public func createResponse(
        input: [Response.InputItem],
        model: ModelID,
        instructions: String? = nil,
        parallelToolCalls: Bool? = nil,
        previousResponseID: String? = nil,
        reasoning: Response.Reasoning? = nil,
        store: Bool? = nil,
        temperature: Double? = nil,
        topP: Double? = nil,
        text: Text? = nil,
        toolChoice: Response.ToolChoice? = nil,
        tools: [Response.Tool] = [],
        truncation: Response.Truncation? = nil,
        user: String? = nil
    ) async throws -> Response {
        let request = try CreateResponseRequest(
            input: input,
            model: model,
            instructions: instructions,
            parallelToolCalls: parallelToolCalls,
            previousResponseID: previousResponseID,
            reasoning: reasoning,
            store: store,
            temperature: temperature,
            topP: topP,
            text: text,
            toolChoice: toolChoice,
            tools: tools,
            truncation: truncation,
            user: user,
            stream: false
        )

        return try await requestHandler.perform(request: request)
    }

    /**
     Create and stream a response.
     POST


     https://api.openai.com/v1/responses

     Creates a model response. Provide text or image inputs to generate text or JSON outputs. Have the model call your own custom code or use built-in tools like web search or file search to use your own data as input for the model's response.
     */
    public func createAndStreamResponse(
        input: [Response.InputItem],
        model: ModelID,
        instructions: String? = nil,
        parallelToolCalls: Bool? = nil,
        previousResponseID: String? = nil,
        reasoning: Response.Reasoning? = nil,
        store: Bool? = nil,
        temperature: Double? = nil,
        topP: Double? = nil,
        text: Text? = nil,
        toolChoice: Response.ToolChoice? = nil,
        tools: [Response.Tool] = [],
        truncation: Response.Truncation? = nil,
        user: String? = nil
    ) async throws -> AsyncThrowingStream<Response.StreamEvent, Error> {
        let request = try CreateResponseRequest(
            input: input,
            model: model,
            instructions: instructions,
            parallelToolCalls: parallelToolCalls,
            previousResponseID: previousResponseID,
            reasoning: reasoning,
            store: store,
            temperature: temperature,
            topP: topP,
            text: text,
            toolChoice: toolChoice,
            tools: tools,
            truncation: truncation,
            user: user,
            stream: true
        )

        return try await requestHandler.stream(request: request)
    }
    
    /**
     Get a model response
     GET
     
     https://api.openai.com/v1/responses/{response_id}
     
     Retrieves a response object by ID.
     */
    public func getResponse(
        responseID: String
    ) async throws -> Response {
        let request = GetModelResponseRequest(responseID: responseID)
        
        return try await requestHandler.perform(request: request)
    }
    
    /**
     List input items
     GET
     
     https://api.openai.com/v1/responses/{response_id}/input_items
     
     List input items for a specific response. Input items are all the items that were sent to create the response, as well as any function call outputs that were submitted through the tool.
     */
    public func listInputItems(
        responseID: String
    ) async throws -> List<Response.InputItem> {
        let request = ListInputItemsRequest(responseID: responseID)
        
        return try await requestHandler.perform(request: request)
    }
}
