import Vapor

protocol ImageSearchServiceProtocol: Sendable {
    func fetchImage(for query: String) async throws -> String?
}

struct GoogleImageService: ImageSearchServiceProtocol {
    private let client: Client
    private let config: AppConfigProtocol

    init(client: Client, config: AppConfigProtocol) {
        self.client = client
        self.config = config
    }

    func fetchImage(for query: String) async throws -> String? {
        let url = "https://www.googleapis.com/customsearch/v1"
        let queryParams: [String: String] = [
            "q": query,
            "searchType": "image",
            "key": config.googleAPIKey,
            "cx": config.googleSearchEngineID,
            "num": "1"
        ]

        let response = try await client.get(URI(string: url), headers: [:]) { req in
            try req.query.encode(queryParams)
        }

        guard let responseBody = response.body,
              let responseData = responseBody.getData(at: 0, length: responseBody.readableBytes) else {
            throw Abort(.notFound, reason: "No response data from Google API")
        }

        let json = try JSONSerialization.jsonObject(with: responseData, options: [])
        if let jsonObject = json as? [String: Any],
           let items = jsonObject["items"] as? [[String: Any]],
           let firstItem = items.first,
           let link = firstItem["link"] as? String {
            return link
        }

        return nil
    }
}
