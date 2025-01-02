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

        // Check for missing response body
        guard let responseBody = response.body else {
            throw Abort(.notFound, reason: "No response data from Google API")
        }

        // Check for empty data in response body
        guard let responseData = responseBody.getData(at: 0, length: responseBody.readableBytes), !responseData.isEmpty else {
            throw Abort(.notFound, reason: "No response data from Google API")
        }

        do {
            let json = try JSONSerialization.jsonObject(with: responseData, options: [])
            guard let jsonObject = json as? [String: Any],
                  let items = jsonObject["items"] as? [[String: Any]] else {
                throw Abort(.badRequest, reason: "Invalid JSON structure or missing data")
            }

            // Handle empty items array
            guard !items.isEmpty else {
                return nil
            }

            // Extract the link from the first item
            guard let firstItem = items.first,
                  let link = firstItem["link"] as? String else {
                throw Abort(.badRequest, reason: "Invalid JSON structure or missing link")
            }

            return link
        } catch {
            throw Abort(.badRequest, reason: "Malformed JSON: \(error.localizedDescription)")
        }
    }
}
