import Vapor

struct ExoplanetController: RouteCollection, Sendable {
    private let exoplanetService: ExoplanetAnalyzerAPIProtocol

    init(exoplanetService: ExoplanetAnalyzerAPIProtocol) {
        self.exoplanetService = exoplanetService
    }

    func boot(routes: RoutesBuilder) throws {
        let exoplanets = routes.grouped("exoplanets")
        exoplanets.get("orphans", use: getOrphanPlanets)
        exoplanets.get("hottest", use: getHottestExoplanet)
        exoplanets.get("timeline", use: getDiscoveryTimeline)
    }

    @Sendable
    func getOrphanPlanets(req: Request) async throws -> [ExoplanetResponse] {
        do {
            return try await exoplanetService.fetchOrphanPlanets()
        } catch {
            throw Abort(.notFound, reason: "No orphan planets found")
        }
    }

    @Sendable
    func getHottestExoplanet(req: Request) async throws -> ExoplanetResponse {
        do {
            return try await exoplanetService.fetchHottestStarExoplanet()
        } catch {
            throw Abort(.notFound, reason: "No hottest star exoplanet found")
        }
    }

    @Sendable
    func getDiscoveryTimeline(req: Request) async throws -> YearlyPlanetSizeDistributionResponse {
        do {
            return try await exoplanetService.fetchDiscoveryTimeline()
        } catch {
            throw Abort(.notFound, reason: "No discovery timeline found")
        }
    }
}
