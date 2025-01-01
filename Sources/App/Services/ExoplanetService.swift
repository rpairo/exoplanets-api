import ExoplanetAPI
import Vapor

protocol ExoplanetAnalyzerAPIProtocol: Sendable {
    func fetchOrphanPlanets() async throws -> [ExoplanetResponse]
    func fetchHottestStarExoplanet() async throws -> ExoplanetResponse
    func fetchDiscoveryTimeline() async throws -> YearlyPlanetSizeDistributionResponse
}

extension Sequence {
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var results = [T]()
        for element in self {
            try await results.append(transform(element))
        }
        return results
    }
}

struct ExoplanetService: ExoplanetAnalyzerAPIProtocol {
    let client: Client

    func fetchOrphanPlanets() async throws -> [ExoplanetResponse] {
        let analyzer = try await ExoplanetAnalyzerAPI()
        guard let orphans = analyzer.getOrphanPlanets() else {
            throw Abort(.notFound, reason: "No orphan planets found")
        }

        return await orphans.asyncMap { dto in
            let imageUrl = try? await fetchImageFromGoogle(for: dto.planetIdentifier ?? "")
            return Mapper.transformToLocalModel(from: dto, imageUrl: imageUrl)
        }
    }

    func fetchHottestStarExoplanet() async throws -> ExoplanetResponse {
        let analyzer = try await ExoplanetAnalyzerAPI()
        guard let hottestExoplanet = analyzer.getHottestStarExoplanet() else {
            throw Abort(.notFound, reason: "No hottest star exoplanet found")
        }
        let imageUrl = try? await fetchImageFromGoogle(for: hottestExoplanet.planetIdentifier ?? "")
        return Mapper.transformToLocalModel(from: hottestExoplanet, imageUrl: imageUrl)
    }

    func fetchDiscoveryTimeline() async throws -> YearlyPlanetSizeDistributionResponse {
        let analyzer = try await ExoplanetAnalyzerAPI()
        guard let timeline = analyzer.getDiscoveryTimeline() else {
            throw Abort(.notFound, reason: "No discovery timeline found")
        }
        let sortedTimeline = timeline.sorted { $0.key < $1.key }
        let items = sortedTimeline.map { (year, planetSizeCount) in
            let size = Mapper.transformToLocalModel(from: planetSizeCount)
            return YearlyPlanetSizeDistributionItemResponse(year: year, planetSizeCount: size)
        }
        return YearlyPlanetSizeDistributionResponse(data: items)
    }

    func fetchImageFromGoogle(for planetIdentifier: String) async throws -> String? {
        guard let apiKey = Environment.get("GOOGLE_API_KEY"),
              let searchEngineId = Environment.get("GOOGLE_SEARCH_ENGINE_ID") else {
            throw Abort(.internalServerError, reason: "Missing API key or Search Engine ID in environment variables")
        }

        let url = "https://www.googleapis.com/customsearch/v1"
        let queryParams: [String: String] = [
            "q": planetIdentifier,
            "searchType": "image",
            "key": apiKey,
            "cx": searchEngineId,
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

struct NasaImageSearchResponse: Content {
    let collection: NasaImageCollection
}

struct NasaImageCollection: Content {
    let items: [NasaImageItem]
}

struct NasaImageItem: Content {
    let links: [NasaImageLink]
}

struct NasaImageLink: Content {
    let href: String
}
