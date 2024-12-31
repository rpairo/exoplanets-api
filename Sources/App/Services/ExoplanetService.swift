import ExoplanetAPI
import Vapor

struct ExoplanetService {
    func fetchOrphanPlanets() async throws -> [VaporExoplanetDTO] {
        let analyzer = try await ExoplanetAnalyzerAPI()
        guard let orphans = analyzer.getOrphanPlanets() else {
            throw Abort(.notFound, reason: "No orphan planets found")
        }
        return orphans.map { Mapper.transformToLocalModel(from: $0) }
    }

    func fetchHottestStarExoplanet() async throws -> VaporExoplanetDTO {
        let analyzer = try await ExoplanetAnalyzerAPI()
        guard let hottestExoplanet = analyzer.getHottestStarExoplanet() else {
            throw Abort(.notFound, reason: "No hottest star exoplanet found")
        }
        return Mapper.transformToLocalModel(from: hottestExoplanet)
    }

    func fetchDiscoveryTimeline() async throws -> VaporYearlyPlanetSizeDistributionDTOResponse {
        let analyzer = try await ExoplanetAnalyzerAPI()
        guard let timeline = analyzer.getDiscoveryTimeline() else {
            throw Abort(.notFound, reason: "No discovery timeline found")
        }
        let sortedTimeline = timeline.sorted { $0.key < $1.key }

        let items = sortedTimeline.map { (year, planetSizeCount) in
            let size = Mapper.transformToLocalModel(from: planetSizeCount)
            return VaporYearlyPlanetSizeDistributionItemDTO(year: year, planetSizeCount: size)
        }

        return VaporYearlyPlanetSizeDistributionDTOResponse(data: items)
    }
}
