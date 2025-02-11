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

    /**
     Create a message.
     POST

     https://api.openai.com/v1/threads/<thread_id>/messages

     Create a message.
     */
    public func createMessage(
        threadID: String,
        message: Thread.Message
    ) async throws -> Message {

        let request = try CreateMessageRequest(
            threadID: threadID,
            message: message
        )

        return try await requestHandler.perform(request: request)
    }

    /**
     List Messages.
     GET

     https://api.openai.com/v1/threads/{thread_id}/messages

     Returns a list of messages for a given thread.
     */
    public func listMessages(
        threadID: String,
        runID: String?
    ) async throws -> [Message] {
        let request = ListMessagesRequest(
            threadID: threadID,
            runID: runID
        )
        return try await requestHandler.perform(request: request)
    }

    /**
     Create a run.
     POST

     https://api.openai.com/v1/threads/<thread_id>/runs

     Create a run.
     */
    public func createRun(
        assistantID: String,
        threadID: String
    ) async throws -> Run {
        let request = try CreateRunRequest(
            threadID: threadID,
            assistantID: assistantID
        )

        return try await requestHandler.perform(request: request)
    }

    /**
     Retrieve a run.
     GET

     https://api.openai.com/v1/threads/{thread_id}/runs/{run_id}

     Retrieve a run.
     */
    public func retrieveRun(
        threadID: String,
        runID: String
    ) async throws -> Run {
        let request = RetrieveRunRequest(threadID: threadID, runID: runID)

        return try await requestHandler.perform(request: request)
    }

    /**
     Submit tool outputs.
     POST

     https://api.openai.com/v1/threads/<thread_id>/runs/<run_id>/submit_tool_outputs

     When a run has the `status: "requires_action"` and `required_action.type` is `submit_tool_outputs`, this endpoint can be used to submit the outputs from the tool calls once they're all completed. All outputs must be submitted in a single request.
     */
    public func submitToolOutput(
        threadID: String,
        runID: String,
        toolOutputs: [ToolOutput]
    ) async throws -> Run {
        let request = try SubmitToolOutputsToRunRequest(
            threadID: threadID,
            runID: runID,
            toolOutputs: toolOutputs
        )

        return try await requestHandler.perform(request: request)
    }
}
