import Vapor

final class MockClient: Client {
    var responseBody: Data?
    var responseStatus: HTTPResponseStatus = .ok
    var shouldThrowError: Bool = false
    var eventLoop: EventLoop

    init(eventLoop: EventLoop = EmbeddedEventLoop()) {
        self.eventLoop = eventLoop
    }

    func delegating(to eventLoop: EventLoop) -> Client {
        MockClient(eventLoop: eventLoop)
    }

    func logging(to logger: Logger) -> Client {
        self
    }

    func allocating(to byteBufferAllocator: ByteBufferAllocator) -> Client {
        self
    }

    func send(_ request: ClientRequest) -> EventLoopFuture<ClientResponse> {
        if shouldThrowError {
            return eventLoop.makeFailedFuture(Abort(.internalServerError, reason: "Mock error"))
        }

        let buffer = responseBody.map { ByteBuffer(data: $0) }
        let response = ClientResponse(status: responseStatus, headers: [:], body: buffer)
        return eventLoop.makeSucceededFuture(response)
    }
}
