import Vapor
@testable import App

final class MockImageSearchService: ImageSearchServiceProtocol {
    var shouldThrowError = false
    var mockImageURL: String?

    func fetchImage(for query: String) async throws -> String? {
        if shouldThrowError {
            throw Abort(.internalServerError, reason: "Mock image service error")
        }
        return mockImageURL
    }
}
