import Vapor

struct ExoplanetController: Sendable {
    private let exoplanetService: ExoplanetService

    init(exoplanetService: ExoplanetService) {
        self.exoplanetService = exoplanetService
    }

    @Sendable
    func getOrphanPlanets(req: Request) async throws -> [VaporExoplanetDTO] {
        do {
            return try await exoplanetService.fetchOrphanPlanets()
        } catch {
            throw Abort(.notFound, reason: "No orphan planets found")
        }
    }

    @Sendable
    func getHottestExoplanet(req: Request) async throws -> VaporExoplanetDTO {
        do {
            return try await exoplanetService.fetchHottestStarExoplanet()
        } catch {
            throw Abort(.notFound, reason: "No hottest star exoplanet found")
        }
    }

    @Sendable
    func getDiscoveryTimeline(req: Request) async throws -> VaporYearlyPlanetSizeDistributionDTOResponse {
        do {
            return try await exoplanetService.fetchDiscoveryTimeline()
        } catch {
            throw Abort(.notFound, reason: "No discovery timeline found")
        }
    }
}
