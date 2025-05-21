//
//  ResponseStreamEvent.swift
//  openai-kit
//
//  Created by Mark DiFranco on 2025-05-18.
//

import Foundation

public extension Response {
    enum StreamEvent: Codable, Hashable, Sendable {
        case created(CreatedEvent)
        case inProgress(InProgressEvent)
        case completed(CompletedEvent)
        case failed(FailedEvent)
        case incomplete(IncompleteEvent)
        case outputItemAdded(OutputItemAddedEvent)
        case outputItemDone(OutputItemDoneEvent)
        case contentPartAdded(ContentPartAddedEvent)
        case contentPartDone(ContentPartDoneEvent)
        case outputTextDelta(OutputTextDeltaEvent)
        case outputTextAnnotationAdded(OutputTextAnnotationAddedEvent)
        case outputTextDone(OutputTextDoneEvent)
        case refusalDelta(RefusalDeltaEvent)
        case refusalDone(RefusalDoneEvent)
        case functionCallArgumentsDelta(FunctionCallArgumentsDeltaEvent)
        case functionCallArgumentsDone(FunctionCallArgumentsDoneEvent)
        case webSearchCallInProgress(WebSearchCallInProgressEvent)
        case webSearchCallSearching(WebSearchCallSearchingEvent)
        case webSearchCallCompleted(WebSearchCallCompletedEvent)
        case reasoningSummaryPartAdded(ReasoningSummaryPartAddedEvent)
        case reasoningSummaryPartDone(ReasoningSummaryPartDoneEvent)
        case reasoningSummaryTextDelta(ReasoningSummaryTextDeltaEvent)
        case reasoningSummaryTextDone(ReasoningSummaryTextDoneEvent)
        case error(ErrorEvent)

        public init(from decoder: Decoder) throws {
            if let event = try? CreatedEvent(from: decoder) {
                self = .created(event)
            } else if let event = try? InProgressEvent(from: decoder) {
                self = .inProgress(event)
            } else if let event = try? CompletedEvent(from: decoder) {
                self = .completed(event)
            } else if let event = try? FailedEvent(from: decoder) {
                self = .failed(event)
            } else if let event = try? IncompleteEvent(from: decoder) {
                self = .incomplete(event)
            } else if let event = try? OutputItemAddedEvent(from: decoder) {
                self = .outputItemAdded(event)
            } else if let event = try? OutputItemDoneEvent(from: decoder) {
                self = .outputItemDone(event)
            } else if let event = try? ContentPartAddedEvent(from: decoder) {
                self = .contentPartAdded(event)
            } else if let event = try? ContentPartDoneEvent(from: decoder) {
                self = .contentPartDone(event)
            } else if let event = try? OutputTextDeltaEvent(from: decoder) {
                self = .outputTextDelta(event)
            } else if let event = try? OutputTextAnnotationAddedEvent(from: decoder) {
                self = .outputTextAnnotationAdded(event)
            } else if let event = try? OutputTextDoneEvent(from: decoder) {
                self = .outputTextDone(event)
            } else if let event = try? RefusalDeltaEvent(from: decoder) {
                self = .refusalDelta(event)
            } else if let event = try? RefusalDoneEvent(from: decoder) {
                self = .refusalDone(event)
            } else if let event = try? FunctionCallArgumentsDeltaEvent(from: decoder) {
                self = .functionCallArgumentsDelta(event)
            } else if let event = try? FunctionCallArgumentsDoneEvent(from: decoder) {
                self = .functionCallArgumentsDone(event)
            } else if let event = try? WebSearchCallInProgressEvent(from: decoder) {
                self = .webSearchCallInProgress(event)
            } else if let event = try? WebSearchCallSearchingEvent(from: decoder) {
                self = .webSearchCallSearching(event)
            } else if let event = try? WebSearchCallCompletedEvent(from: decoder) {
                self = .webSearchCallCompleted(event)
            } else if let event = try? ReasoningSummaryPartAddedEvent(from: decoder) {
                self = .reasoningSummaryPartAdded(event)
            } else if let event = try? ReasoningSummaryPartDoneEvent(from: decoder) {
                self = .reasoningSummaryPartDone(event)
            } else if let event = try? ReasoningSummaryTextDeltaEvent(from: decoder) {
                self = .reasoningSummaryTextDelta(event)
            } else if let event = try? ReasoningSummaryTextDoneEvent(from: decoder) {
                self = .reasoningSummaryTextDone(event)
            } else if let event = try? ErrorEvent(from: decoder) {
                self = .error(event)
            } else {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decode(String.self, forKey: .type)
                throw DecodingError.dataCorruptedError(
                    forKey: .type,
                    in: container,
                    debugDescription: "Unrecognized event type: \(type)"
                )
            }
        }

        public func encode(to encoder: any Encoder) throws {
            switch self {
            case .created(let event):
                try event.encode(to: encoder)
            case .inProgress(let event):
                try event.encode(to: encoder)
            case .completed(let event):
                try event.encode(to: encoder)
            case .failed(let event):
                try event.encode(to: encoder)
            case .incomplete(let event):
                try event.encode(to: encoder)
            case .outputItemAdded(let event):
                try event.encode(to: encoder)
            case .outputItemDone(let event):
                try event.encode(to: encoder)
            case .contentPartAdded(let event):
                try event.encode(to: encoder)
            case .contentPartDone(let event):
                try event.encode(to: encoder)
            case .outputTextDelta(let event):
                try event.encode(to: encoder)
            case .outputTextAnnotationAdded(let event):
                try event.encode(to: encoder)
            case .outputTextDone(let event):
                try event.encode(to: encoder)
            case .refusalDelta(let event):
                try event.encode(to: encoder)
            case .refusalDone(let event):
                try event.encode(to: encoder)
            case .functionCallArgumentsDelta(let event):
                try event.encode(to: encoder)
            case .functionCallArgumentsDone(let event):
                try event.encode(to: encoder)
            case .webSearchCallInProgress(let event):
                try event.encode(to: encoder)
            case .webSearchCallSearching(let event):
                try event.encode(to: encoder)
            case .webSearchCallCompleted(let event):
                try event.encode(to: encoder)
            case .reasoningSummaryPartAdded(let event):
                try event.encode(to: encoder)
            case .reasoningSummaryPartDone(let event):
                try event.encode(to: encoder)
            case .reasoningSummaryTextDelta(let event):
                try event.encode(to: encoder)
            case .reasoningSummaryTextDone(let event):
                try event.encode(to: encoder)
            case .error(let event):
                try event.encode(to: encoder)
            }
        }

        private enum CodingKeys: String, CodingKey {
            case type
        }
    }
}

public extension Response {
    /// Payload for the `response.created` server-sent event.
    struct CreatedEvent: Codable, Hashable, Sendable {
        public let type: `Type`
        /// The response object.
        public let response: Response

        public enum `Type`: String, Codable, Hashable, Sendable {
            case responseCreated = "response.created"
        }
    }

    /// Payload for the `response.in_progress` server-sent event.
    struct InProgressEvent: Codable, Hashable, Sendable {
        public let type: `Type`
        /// The response object.
        public let response: Response

        public enum `Type`: String, Codable, Hashable, Sendable {
            case responseInProgress = "response.in_progress"
        }
    }

    /// Payload for the `response.completed` server-sent event.
    struct CompletedEvent: Codable, Hashable, Sendable {
        public let type: `Type`
        /// The response object.
        public let response: Response

        public enum `Type`: String, Codable, Hashable, Sendable {
            case responseCompleted = "response.completed"
        }
    }

    /// Payload for the `response.failed` server-sent event.
    struct FailedEvent: Codable, Hashable, Sendable {
        public let type: `Type`
        /// The response object.
        public let response: Response

        public enum `Type`: String, Codable, Hashable, Sendable {
            case responseFailed = "response.failed"
        }
    }

    /// Payload for the `response.incomplete` server-sent event.
    struct IncompleteEvent: Codable, Hashable, Sendable {
        public let type: `Type`
        /// The response object.
        public let response: Response

        public enum `Type`: String, Codable, Hashable, Sendable {
            case responseIncomplete = "response.incomplete"
        }
    }

    /// Payload for the `response.output_item.added` server-sent event.
    struct OutputItemAddedEvent: Codable, Hashable, Sendable {
        public let type: `Type`
        /// The response object.
        public let outputIndex: Int
        /// The output item that was added.
        public let item: OutputItem

        public enum `Type`: String, Codable, Hashable, Sendable {
            case outputItemAdded = "response.output_item.added"
        }
    }

    /// Payload for the `response.output_item.done` server-sent event.
    struct OutputItemDoneEvent: Codable, Hashable, Sendable {
        public let type: `Type`
        /// The index of the output item that was marked done.
        public let outputIndex: Int
        /// The output item that was completed.
        public let item: OutputItem

        public enum `Type`: String, Codable, Hashable, Sendable {
            case outputItemDone = "response.output_item.done"
        }
    }

    /// Payload for the `response.content_part.added` server-sent event.
    struct ContentPartAddedEvent: Codable, Hashable, Sendable {
        public let type: `Type`
        public let contentIndex: Int
        public let outputIndex: Int
        public let itemId: String
        public let part: ContentPart

        public enum `Type`: String, Codable, Hashable, Sendable {
            case contentPartAdded = "response.content_part.added"
        }
    }

    /// Payload for the `response.content_part.done` server-sent event.
    struct ContentPartDoneEvent: Codable, Hashable, Sendable {
        public let type: `Type`
        public let itemId: String
        public let contentIndex: Int
        public let outputIndex: Int
        public let part: ContentPart

        public enum `Type`: String, Codable, Hashable, Sendable {
            case contentPartDone = "response.content_part.done"
        }
    }

    /// Payload for the `response.output_text.delta` server-sent event.
    struct OutputTextDeltaEvent: Codable, Hashable, Sendable {
        public let type: `Type`
        public let itemId: String
        public let contentIndex: Int
        public let outputIndex: Int
        public let delta: String

        public enum `Type`: String, Codable, Hashable, Sendable {
            case outputTextDeltaAdded = "response.output_text.delta"
        }
    }

    /// Payload for the `response.output_text.annotation.added` server-sent event.
    struct OutputTextAnnotationAddedEvent: Codable, Hashable, Sendable {
        /// The type of event, should be "response.output_text.annotation.delta".
        public let type: `Type`
        public let itemId: String
        public let contentIndex: Int
        public let outputIndex: Int
        public let annotationIndex: Int
        public let annotation: Annotation

        public enum `Type`: String, Codable, Hashable, Sendable {
            case outputTextAnnotationAdded = "response.output_text.annotation.added"
        }
    }

    /// Payload for the `response.output_text.done` server-sent event.
    struct OutputTextDoneEvent: Codable, Hashable, Sendable {
        public let type: `Type`
        public let itemId: String
        public let contentIndex: Int
        public let outputIndex: Int
        public let text: String

        public enum `Type`: String, Codable, Hashable, Sendable {
            case textDone = "response.output_text.done"
        }
    }

    /// Payload for the `response.refusal.delta` server-sent event.
    struct RefusalDeltaEvent: Codable, Hashable, Sendable {
        public let type: `Type`
        public let itemId: String
        public let contentIndex: Int
        public let outputIndex: Int
        public let delta: String

        public enum `Type`: String, Codable, Hashable, Sendable {
            case refusalDelta = "response.refusal.delta"
        }
    }

    /// Payload for the `response.refusal.done` server-sent event.
    struct RefusalDoneEvent: Codable, Hashable, Sendable {
        public let type: `Type`
        public let itemId: String
        public let contentIndex: Int
        public let outputIndex: Int
        public let refusal: String

        public enum `Type`: String, Codable, Hashable, Sendable {
            case refusalDone = "response.refusal.done"
        }
    }

    /// Payload for the `response.function_call.arguments.delta` server-sent event.
    struct FunctionCallArgumentsDeltaEvent: Codable, Hashable, Sendable {
        public let type: `Type`
        public let delta: String
        public let itemId: String
        public let outputIndex: Int

        public enum `Type`: String, Codable, Hashable, Sendable {
            case functionCallArgumentsDetla = "response.function_call_arguments.delta"
        }
    }

    /// Payload for the `response.function_call.arguments.done` server-sent event.
    struct FunctionCallArgumentsDoneEvent: Codable, Hashable, Sendable {
        public let type: `Type`
        public let itemId: String
        public let outputIndex: Int
        public let arguments: String

        public enum `Type`: String, Codable, Hashable, Sendable {
            case functionCallArgumentsDone = "response.function_call_arguments.done"
        }
    }

    /// Payload for the `response.web_search_call.in_progress` server-sent event.
    struct WebSearchCallInProgressEvent: Codable, Hashable, Sendable {
        public let type: `Type`
        public let itemId: String
        public let outputIndex: Int

        public enum `Type`: String, Codable, Hashable, Sendable {
            case webSearchCallInProgress = "response.web_search_call.in_progress"
        }
    }

    /// Payload for the `response.web_search_call.searching` server-sent event.
    struct WebSearchCallSearchingEvent: Codable, Hashable, Sendable {
        public let type: `Type`
        public let itemId: String
        public let outputIndex: Int

        public enum `Type`: String, Codable, Hashable, Sendable {
            case webSearchCallSearching = "response.web_search_call.searching"
        }
    }

    /// Payload for the `response.web_search_call.completed` server-sent event.
    struct WebSearchCallCompletedEvent: Codable, Hashable, Sendable {
        public let type: `Type`
        public let itemId: String
        public let outputIndex: Int

        public enum `Type`: String, Codable, Hashable, Sendable {
            case webSearchCallCompleted = "response.web_search_call.completed"
        }
    }

    /// Payload for the `response.reasoning_summary_part.added` server-sent event.
    struct ReasoningSummaryPartAddedEvent: Codable, Hashable, Sendable {
        public let type: `Type`
        public let itemId: String
        public let outputIndex: Int
        public let summaryIndex: Int
        public let part: Response.OutputItem.Reasoning.SummaryText

        public enum `Type`: String, Codable, Hashable, Sendable {
            case reasoningSummaryPartAdded = "response.reasoning_summary_part.added"
        }
    }

    /// Payload for the `response.reasoning_summary_part.done` server-sent event.
    struct ReasoningSummaryPartDoneEvent: Codable, Hashable, Sendable {
        public let type: `Type`
        public let itemId: String
        public let outputIndex: Int
        public let summaryIndex: Int
        public let part: OutputItem.Reasoning.SummaryText

        public enum `Type`: String, Codable, Hashable, Sendable {
            case reasoningSummaryPartDone = "response.reasoning_summary_part.done"
        }
    }

    /// Payload for the `response.reasoning_summary_text.delta` server-sent event.
    struct ReasoningSummaryTextDeltaEvent: Codable, Hashable, Sendable {
        public let type: `Type`
        public let itemId: String
        public let outputIndex: Int
        public let summaryIndex: Int
        public let delta: String

        public enum `Type`: String, Codable, Hashable, Sendable {
            case reasoningSummaryPartDone = "response.reasoning_summary_text.delta"
        }
    }

    /// Payload for the `response.reasoning_summary.text.done` server-sent event.
    struct ReasoningSummaryTextDoneEvent: Codable, Hashable, Sendable {
        public let type: `Type`
        public let itemId: String
        public let outputIndex: Int
        public let summaryIndex: Int
        public let text: String

        public enum `Type`: String, Codable, Hashable, Sendable {
            case reasoningSummaryPartDone = "response.reasoning_summary_text.done"
        }
    }

    /// Payload for the `response.error` server-sent event.
    struct ErrorEvent: Codable, Hashable, Sendable {
        public let type: String
        public let message: String
        public let code: String?
        public let param: String?
    }
}
