import ExoplanetsAPI
import Vapor

protocol ExoplanetAnalyzerAPIProtocol: Sendable {
    func fetchOrphanPlanets() async throws -> [ExoplanetResponse]
    func fetchHottestStarExoplanet() async throws -> ExoplanetResponse
    func fetchDiscoveryTimeline() async throws -> YearlyPlanetSizeDistributionResponse
}

struct ExoplanetService: ExoplanetAnalyzerAPIProtocol {
    let client: Client
    let imageService: ImageSearchServiceProtocol

    func fetchOrphanPlanets() async throws -> [ExoplanetResponse] {
        let analyzer = try await ExoplanetAnalyzerAPI()
        guard let orphans = analyzer.getOrphanPlanets() else {
            throw Abort(.notFound, reason: "No orphan planets found")
        }

        return await orphans.asyncMap { dto in
            let imageUrl = try? await imageService.fetchImage(for: dto.planetIdentifier ?? "")
            return Mapper.transformToLocalModel(from: dto, imageUrl: imageUrl)
        }
    }

    func fetchHottestStarExoplanet() async throws -> ExoplanetResponse {
        let analyzer = try await ExoplanetAnalyzerAPI()
        guard let hottestExoplanet = analyzer.getHottestStarExoplanet() else {
            throw Abort(.notFound, reason: "No hottest star exoplanet found")
        }
        let imageUrl = try? await imageService.fetchImage(for: hottestExoplanet.planetIdentifier ?? "")
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
