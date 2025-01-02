import Vapor

final class TestViewRenderer: ViewRenderer {
    var eventLoop: EventLoop

    init(eventLoop: EventLoop = EmbeddedEventLoop()) {
        self.eventLoop = eventLoop
    }

    func render<E>(_ name: String, _ context: E) -> EventLoopFuture<View> where E: Encodable {
        let view = View(data: ByteBuffer(string: name))
        return eventLoop.makeSucceededFuture(view)
    }

    func render(_ name: String) -> EventLoopFuture<View> {
        let view = View(data: ByteBuffer(string: name))
        return eventLoop.makeSucceededFuture(view)
    }

    func `for`(_ request: Vapor.Request) -> any Vapor.ViewRenderer {
        return self
    }
}
