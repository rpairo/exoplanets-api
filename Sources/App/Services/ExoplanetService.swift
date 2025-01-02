@preconcurrency import ExoplanetsAPI
import Vapor

protocol ExoplanetAnalyzerServiceable: Sendable {
    func fetchOrphanPlanets() async throws -> [ExoplanetResponse]
    func fetchHottestStarExoplanet() async throws -> ExoplanetResponse
    func fetchDiscoveryTimeline() async throws -> YearlyPlanetSizeDistributionResponse
}

struct ExoplanetService: ExoplanetAnalyzerServiceable {
    private let client: Client
    private let imageService: ImageSearchServiceProtocol
    private let analyzer: ExoplanetAnalyzerAPIProtocol

    init(client: Client, imageService: ImageSearchServiceProtocol, analyzer: ExoplanetAnalyzerAPIProtocol) {
        self.client = client
        self.imageService = imageService
        self.analyzer = analyzer
    }

    func fetchOrphanPlanets() async throws -> [ExoplanetResponse] {
        guard let orphans = analyzer.getOrphanPlanets() else {
            throw Abort(.notFound, reason: "No orphan planets found")
        }

        return await orphans.asyncMap { dto in
            let imageUrl = try? await imageService.fetchImage(for: dto.planetIdentifier ?? "")
            return Mapper.transformToLocalModel(from: dto, imageUrl: imageUrl)
        }
    }

    func fetchHottestStarExoplanet() async throws -> ExoplanetResponse {
        guard let hottestExoplanet = analyzer.getHottestStarExoplanet() else {
            throw Abort(.notFound, reason: "No hottest star exoplanet found")
        }
        let imageUrl = try? await imageService.fetchImage(for: hottestExoplanet.planetIdentifier ?? "")
        return Mapper.transformToLocalModel(from: hottestExoplanet, imageUrl: imageUrl)
    }

    func fetchDiscoveryTimeline() async throws -> YearlyPlanetSizeDistributionResponse {
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
}

extension Sequence {
    func asyncMap<T>(_ transform: (Element) async throws -> T) async rethrows -> [T] {
        var results = [T]()
        for element in self {
            try await results.append(transform(element))
        }
        return results
    }
}
