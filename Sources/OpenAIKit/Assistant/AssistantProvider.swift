//
//  AssistantProvider.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-02-10.
//

import Foundation

public struct AssistantProvider: Sendable {

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
        metadata: [String: String]? = nil,
        temperature: Double? = nil,
        topP: Double? = nil,
        responseFormat: ResponseFormat? = nil
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
     Modify an assistant.
     POST

     https://api.openai.com/v1/assistants/<assistant_id>

     Modifies an assistant.
     */
    public func modifyAssistant(
        assistantID: String,
        model: ModelID? = nil,
        name: String? = nil,
        instructions: String? = nil,
        reasoningEffort: Assistant.ReasoningEffort? = nil,
        tools: [Assistant.Tool]? = nil,
        metadata: [String: String]? = nil,
        temperature: Double? = nil,
        topP: Double? = nil,
        responseFormat: ResponseFormat? = nil
    ) async throws -> Assistant {

        let request = try ModifyAssistantRequest(
            assistantId: assistantID,
            model: model?.id,
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
     Retrieve an assistant.
     GET

     https://api.openai.com/v1/assistants/<assistant_id>

     Retrieve an assistant.
     */
    public func retrieveAssistant(
        assistantID: String
    ) async throws -> Assistant {
        let request = RetrieveAssistantRequest(assistantID: assistantID)

        return try await requestHandler.perform(request: request)
    }

    /**
     Delete an assistant.
     DELETE

     https://api.openai.com/v1/assistants/<assistant_id>

     Delete an assistant.
     */
    public func deleteAssistant(
        assistantID: String
    ) async throws -> DeletedResponse {
        let request = DeleteAssistantRequest(assistantID: assistantID)

        return try await requestHandler.perform(request: request)
    }

    /**
     Create a thread.
     POST

     https://api.openai.com/v1/threads

     Create a thread.
     */
    public func createThread(
        messages: [Thread.Message] = [],
        metadata: [String: String]? = nil
    ) async throws -> Thread {

        let request = try CreateThreadRequest(
            messages: messages,
            metadata: metadata
        )

        return try await requestHandler.perform(request: request)
    }

    /**
     Delete a thread.
     DELETE

     https://api.openai.com/v1/threads/<thread_id>

     Delete a thread.
     */
    public func deleteThread(
        threadID: String
    ) async throws -> DeletedResponse {
        let request = DeleteThreadRequest(threadID: threadID)

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
    ) async throws -> List<Message> {
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
        threadID: String,
        tools: [Assistant.Tool]? = nil,
        toolChoice: Run.ToolChoice? = nil
    ) async throws -> Run {
        let request = try CreateRunRequest(
            threadID: threadID,
            assistantID: assistantID,
            tools: tools,
            toolChoice: toolChoice
        )

        return try await requestHandler.perform(request: request)
    }

    /**
     Create and stream a run.
     POST

     https://api.openai.com/v1/threads/<thread_id>/runs

     Create a run.
     */
    public func createAndStreamRun(
        assistantID: String,
        threadID: String,
        tools: [Assistant.Tool]? = nil,
        toolChoice: Run.ToolChoice? = nil
    ) async throws -> AsyncThrowingStream<String, Error> {
        let request = try CreateRunRequest(
            threadID: threadID,
            assistantID: assistantID,
            tools: tools,
            toolChoice: toolChoice,
            stream: true
        )

        return try await requestHandler.stream(request: request)
    }

    /**
     List runs.

     https://api.openai.com/v1/threads/{thread_id}/runs

     Returns a list of runs belonging to a thread.
     */
    public func listRuns(
        threadID: String
    ) async throws -> List<Run> {
        let request = ListRunsRequest(threadID: threadID)

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
     POST

     https://api.openai.com/v1/threads/<thread_id>/runs/<run_id>/cancel

     Cancel a run.
     */
    public func cancelRun(
        threadID: String,
        runID: String
    ) async throws -> Run {
        let request = CancelRunRequest(threadID: threadID, runID: runID)

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

    /**
     Polls a run until it completes, then retrieves the latest assistant message.

     - Parameters:
        - threadID: The ID of the thread.
        - runID: The ID of the run.
        - pollInterval: The number of seconds to wait between poll requests.

     - Throws: An error if the polling or message retrieval fails.

     - Returns: The latest assistant messages after the run completes, any tool calls, and the Run.
     */
    public func pollRunForAssistantResponse(
        threadID: String,
        runID: String,
        pollInterval: TimeInterval = 2
    ) async throws -> PollRunResponse {
        var run: Run
        repeat {
            try await Task.sleep(nanoseconds: UInt64(pollInterval) * 1_000_000_000)
            run = try await retrieveRun(threadID: threadID, runID: runID)
        } while run.status == .queued || run.status == .inProgress || run.status == .cancelling

        switch run.status {
        case .completed:
            let messagesList = try await listMessages(
                threadID: threadID,
                runID: runID
            )
            // Get only the last contiguous assistant messages
            var latestAssistantMessages: [Message] = []
            for message in messagesList.data.reversed() {
                if message.role == .assistant {
                    latestAssistantMessages.insert(message, at: 0)
                } else {
                    break
                }
            }
            return .messages(run, latestAssistantMessages)
        case .requiresAction:
            guard let toolCalls = run.requiredAction?.submitToolOutputs.toolCalls else {
                throw RunError.missingToolCalls()
            }
            return .requiresAction(run, toolCalls)
        case .incomplete:
            throw RunError.incomplete(run.incompleteDetails)
        case .failed:
            throw RunError.failed(run.lastError)
        case .cancelled:
            throw RunError.cancelled()
        case .expired:
            throw RunError.expired()
        case .queued, .inProgress, .cancelling:
            throw RunError.invalidState()
        }
    }
}

public enum PollRunResponse {
    case messages(Run, [Message])
    case requiresAction(Run, [Run.ToolCall])
}

// MARK: - RunError

public struct RunError: LocalizedError {
    public let errorDescription: String?
    public let failureReason: String?
}

extension RunError {
    static func failed(_ lastError: Run.LastError?) -> RunError {
        let message = lastError.map { "[Error Code \($0.code)] \($0.message)" } ?? "Run failed."
        return RunError(errorDescription: message, failureReason: "Run failed.")
    }

    static func incomplete(_ incompleteDetails: Run.IncompleteDetails?) -> RunError {
        RunError(
            errorDescription: incompleteDetails?.reason ?? "Run incomplete.",
            failureReason: "Run incomplete.")
    }

    static func cancelled() -> RunError {
        RunError(errorDescription: "Run cancelled.", failureReason: "Run cancelled.")
    }

    static func expired() -> RunError {
        RunError(errorDescription: "Run expired.", failureReason: "Run expired.")
    }

    static func invalidState() -> RunError {
        RunError(
            errorDescription: "Run is in an invalid state.",
            failureReason: "Run is in an invalid state.")
    }

    static func missingToolCalls() -> RunError {
        RunError(
            errorDescription: "Run requires tool calls but none were returned.",
            failureReason: "Run requires tool calls but none were returned.")
    }
}
