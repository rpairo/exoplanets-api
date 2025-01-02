import Vapor

protocol AppConfigProtocol: Sendable {
    var googleAPIKey: String { get }
    var googleSearchEngineID: String { get }
}

struct AppConfig: AppConfigProtocol {
    let googleAPIKey: String
    let googleSearchEngineID: String

    init() {
        guard let googleAPIKey = Environment.get("GOOGLE_API_KEY"),
              let googleSearchEngineID = Environment.get("GOOGLE_SEARCH_ENGINE_ID") else {
            fatalError("Missing required environment variables: GOOGLE_API_KEY or GOOGLE_SEARCH_ENGINE_ID")
        }

        self.googleAPIKey = googleAPIKey
        self.googleSearchEngineID = googleSearchEngineID
    }
}
