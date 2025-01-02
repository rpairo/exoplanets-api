import Vapor
@testable import App

final class MockExoplanetService: ExoplanetAnalyzerServiceable {
    var orphanPlanets: [ExoplanetResponse]?
    var hottestExoplanet: ExoplanetResponse?
    var discoveryTimeline: YearlyPlanetSizeDistributionResponse?

    func fetchOrphanPlanets() async throws -> [ExoplanetResponse] {
        guard let orphanPlanets = orphanPlanets, !orphanPlanets.isEmpty else {
            throw Abort(.notFound, reason: "No orphan planets found")
        }
        return orphanPlanets
    }

    func fetchHottestStarExoplanet() async throws -> ExoplanetResponse {
        guard let exoplanet = hottestExoplanet else {
            throw Abort(.notFound, reason: "No hottest star exoplanet found")
        }
        return exoplanet
    }

    func fetchDiscoveryTimeline() async throws -> YearlyPlanetSizeDistributionResponse {
        guard let timeline = discoveryTimeline, !timeline.data.isEmpty else {
            throw Abort(.notFound, reason: "No discovery timeline found")
        }
        return timeline
    }
}
