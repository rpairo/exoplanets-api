import XCTVapor
@testable import App

final class NotFoundMiddlewareTests: XCTestCase {
    var app: Application!

    override func setUpWithError() throws {
        app = Application(.testing)
        app.middleware.use(NotFoundMiddleware())

        app.get("test") { req in
            return "Test Route"
        }
    }

    override func tearDownWithError() throws {
        app.shutdown()
    }

    func testRouteExists() throws {
        try app.test(.GET, "test") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "Test Route")
        }
    }

    func testRouteNotFound() throws {
        try app.test(.GET, "nonexistent") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertTrue(res.body.string.contains("The requested route does not exist."))
        }
    }

    func testInternalServerError() throws {
        app.get("error") { req -> String in
            throw Abort(.internalServerError, reason: "An unexpected error occurred.")
        }

        try app.test(.GET, "error") { res in
            XCTAssertEqual(res.status, .internalServerError)
            XCTAssertTrue(res.body.string.contains("An unexpected error occurred."))
        }
    }
}

fileprivate extension XCTHTTPResponse {
    var bodyString: String {
        guard let string = body.getString(at: 0, length: body.readableBytes) else {
            return ""
        }
        return string
    }
}

fileprivate extension String {
    init?(buffer: ByteBuffer) {
        self.init(bytes: buffer.readableBytesView, encoding: .utf8)
    }
}
