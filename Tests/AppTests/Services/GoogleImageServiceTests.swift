import XCTest
import Vapor
@testable import App

final class GoogleImageServiceTests: XCTestCase {
    private var mockClient: MockClient!
    private var mockConfig: MockAppConfig!
    private var service: GoogleImageService!

    override func setUp() {
        super.setUp()
        mockClient = MockClient()
        mockConfig = MockAppConfig(googleAPIKey: "test-google-api-key", googleSearchEngineID: "test-search-engine-id")
        service = GoogleImageService(client: mockClient, config: mockConfig)
    }

    override func tearDown() {
        mockClient = nil
        mockConfig = nil
        service = nil
        super.tearDown()
    }

    func test_fetchImage_withValidResponse_shouldReturnImageURL() async throws {
        mockClient.responseBody = """
        {
            "items": [
                { "link": "https://example.com/image.jpg" }
            ]
        }
        """.data(using: .utf8)

        let imageUrl = try await service.fetchImage(for: "test query")

        XCTAssertEqual(imageUrl, "https://example.com/image.jpg")
    }

    func test_fetchImage_withEmptyItems_shouldReturnNil() async throws {
        mockClient.responseBody = """
        {
            "items": []
        }
        """.data(using: .utf8)

        let imageUrl = try await service.fetchImage(for: "test query")

        XCTAssertNil(imageUrl)
    }

    func test_fetchImage_withMalformedJSON_shouldThrowBadRequest() async throws {
        mockClient.responseBody = """
        { "invalid": "json" }
        """.data(using: .utf8)

        do {
            _ = try await service.fetchImage(for: "test query")
            XCTFail("Expected fetchImage to throw an error for malformed JSON")
        } catch let error as Abort {
            XCTAssertEqual(error.status, .badRequest)
            XCTAssertTrue(error.reason.contains("Malformed JSON"))
        }
    }

    func test_fetchImage_withNoResponseData_shouldThrowNotFound() async throws {
        mockClient.responseBody = nil

        do {
            _ = try await service.fetchImage(for: "test query")
            XCTFail("Expected fetchImage to throw an error for missing response data")
        } catch let error as Abort {
            XCTAssertEqual(error.status, .notFound)
            XCTAssertEqual(error.reason, "No response data from Google API")
        }
    }
}
