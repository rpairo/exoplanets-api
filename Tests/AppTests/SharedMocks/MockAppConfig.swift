@testable import App

struct MockAppConfig: AppConfigProtocol {
    let googleAPIKey: String
    let googleSearchEngineID: String
}
