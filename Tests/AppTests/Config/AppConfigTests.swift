import XCTest
import Vapor
@testable import App

final class AppConfigTests: XCTestCase {
    // MARK: - Properties
    private var originalEnvironment: [String: String] = [:]

    // MARK: - Helper Methods
    private func saveEnvironmentVariables() {
        originalEnvironment["GOOGLE_API_KEY"] = getenv("GOOGLE_API_KEY").flatMap { String(cString: $0) }
        originalEnvironment["GOOGLE_SEARCH_ENGINE_ID"] = getenv("GOOGLE_SEARCH_ENGINE_ID").flatMap { String(cString: $0) }
    }

    private func restoreEnvironmentVariables() {
        for (key, value) in originalEnvironment {
            if value.isEmpty {
                unsetenv(key)
            } else {
                setenv(key, value, 1)
            }
        }
    }

    private func setEnvironmentVariables(googleAPIKey: String?, googleSearchEngineID: String?) {
        if let googleAPIKey = googleAPIKey {
            setenv("GOOGLE_API_KEY", googleAPIKey, 1)
        } else {
            unsetenv("GOOGLE_API_KEY")
        }

        if let googleSearchEngineID = googleSearchEngineID {
            setenv("GOOGLE_SEARCH_ENGINE_ID", googleSearchEngineID, 1)
        } else {
            unsetenv("GOOGLE_SEARCH_ENGINE_ID")
        }
    }

    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        saveEnvironmentVariables()
    }

    override func tearDown() {
        restoreEnvironmentVariables()
        super.tearDown()
    }

    // MARK: - Tests
    func test_AppConfig_withValidEnvironmentVariables_shouldInitializeSuccessfully() throws {
        setEnvironmentVariables(googleAPIKey: "test-google-api-key", googleSearchEngineID: "test-search-engine-id")

        let config = try AppConfig()

        XCTAssertEqual(config.googleAPIKey, "test-google-api-key")
        XCTAssertEqual(config.googleSearchEngineID, "test-search-engine-id")
    }

    func test_AppConfig_withMissingGoogleAPIKey_shouldThrowSpecificError() {
        setEnvironmentVariables(googleAPIKey: nil, googleSearchEngineID: "test-search-engine-id")

        do {
            _ = try AppConfig()
            XCTFail("Expected AppConfig to throw an error when GOOGLE_API_KEY is missing")
        } catch {
            XCTAssertEqual(error as? AppConfigError, AppConfigError.missingGoogleAPIKeyEnvironmentVariables)
        }
    }

    func test_AppConfig_withMissingGoogleSearchEngineID_shouldThrowSpecificError() {
        setEnvironmentVariables(googleAPIKey: "test-google-api-key", googleSearchEngineID: nil)

        do {
            _ = try AppConfig()
            XCTFail("Expected AppConfig to throw an error when GOOGLE_SEARCH_ENGINE_ID is missing")
        } catch {
            XCTAssertEqual(error as? AppConfigError, AppConfigError.missingGoogleSearchEngineIDEnvironmentVariables)
        }
    }

    func test_AppConfig_withBothEnvironmentVariablesMissing_shouldThrowGoogleAPIKeyErrorFirst() {
        setEnvironmentVariables(googleAPIKey: nil, googleSearchEngineID: nil)

        do {
            _ = try AppConfig()
            XCTFail("Expected AppConfig to throw an error when both environment variables are missing")
        } catch {
            XCTAssertEqual(error as? AppConfigError, AppConfigError.missingGoogleAPIKeyEnvironmentVariables)
        }
    }
}
