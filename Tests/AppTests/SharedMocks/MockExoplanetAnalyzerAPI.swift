import Vapor
@testable import ExoplanetsAPI
@testable import App

final class MockExoplanetAnalyzerAPI: ExoplanetAnalyzerAPIProtocol {
    var mockOrphanPlanets: [ExoplanetDTO]?
    var mockHottestExoplanet: ExoplanetDTO?
    var mockDiscoveryTimeline: YearlyPlanetSizeDistributionDTO?

    func getOrphanPlanets() -> [ExoplanetDTO]? {
        mockOrphanPlanets
    }

    func getHottestStarExoplanet() -> ExoplanetDTO? {
        mockHottestExoplanet
    }

    func getDiscoveryTimeline() -> YearlyPlanetSizeDistributionDTO? {
        mockDiscoveryTimeline
    }
}
