import AsyncHTTPClient
import Foundation
import NIO
import NIOHTTP1

public struct Client: Sendable {

    public let audio: AudioProvider
    public let chats: ChatProvider
    public let assistants: AssistantProvider
    public let responses: ResponsesProvider
    public let completions: CompletionProvider
    public let edits: EditProvider
    public let embeddings: EmbeddingProvider
    public let files: FileProvider
    public let images: ImageProvider
    public let models: ModelProvider
    public let moderations: ModerationProvider

    init(requestHandler: RequestHandler) {
        self.audio = AudioProvider(requestHandler: requestHandler)
        self.models = ModelProvider(requestHandler: requestHandler)
        self.completions = CompletionProvider(requestHandler: requestHandler)
        self.chats = ChatProvider(requestHandler: requestHandler)
        self.assistants = AssistantProvider(requestHandler: requestHandler)
        self.responses = ResponsesProvider(requestHandler: requestHandler)
        self.edits = EditProvider(requestHandler: requestHandler)
        self.images = ImageProvider(requestHandler: requestHandler)
        self.embeddings = EmbeddingProvider(requestHandler: requestHandler)
        self.files = FileProvider(requestHandler: requestHandler)
        self.moderations = ModerationProvider(requestHandler: requestHandler)
    }

    public init(
        httpClient: HTTPClient,
        configuration: Configuration
    ) {
        let requestHandler = NIORequestHandler(
            httpClient: httpClient,
            configuration: configuration
        )
        self.init(requestHandler: requestHandler)
    }

    #if !os(Linux)
        public init(
            session: URLSession,
            configuration: Configuration
        ) {
            let requestHandler = URLSessionRequestHandler(
                session: session,
                configuration: configuration
            )
            self.init(requestHandler: requestHandler)
        }
    #endif
}
