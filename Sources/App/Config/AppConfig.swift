import Vapor

enum AppConfigError: Error, LocalizedError {
    case missingGoogleAPIKeyEnvironmentVariables
    case missingGoogleSearchEngineIDEnvironmentVariables

    var errorDescription: String? {
        switch self {
        case .missingGoogleAPIKeyEnvironmentVariables:
            return "Missing required environment variables: GOOGLE_API_KEY"
        case .missingGoogleSearchEngineIDEnvironmentVariables:
            return "Missing required environment variables: GOOGLE_SEARCH_ENGINE_ID"
        }
    }
}

protocol AppConfigProtocol: Sendable {
    var googleAPIKey: String { get }
    var googleSearchEngineID: String { get }
}

struct AppConfig: AppConfigProtocol {
    let googleAPIKey: String
    let googleSearchEngineID: String

    init() throws {
        guard let googleAPIKey = Environment.get("GOOGLE_API_KEY") else {
            throw AppConfigError.missingGoogleAPIKeyEnvironmentVariables
        }

        guard let googleSearchEngineID = Environment.get("GOOGLE_SEARCH_ENGINE_ID") else {
            throw AppConfigError.missingGoogleSearchEngineIDEnvironmentVariables
        }

        self.googleAPIKey = googleAPIKey
        self.googleSearchEngineID = googleSearchEngineID
    }
}
