import Vapor

struct ExoplanetsAPIController: RouteCollection, Sendable {
    private let exoplanetService: ExoplanetAnalyzerAPIProtocol

    init(exoplanetService: ExoplanetAnalyzerAPIProtocol) {
        self.exoplanetService = exoplanetService
    }

    func boot(routes: RoutesBuilder) throws {
        let exoplanets = routes.grouped("api")
        exoplanets.get("orphans", use: getOrphanPlanets)
        exoplanets.get("hottest", use: getHottestExoplanet)
        exoplanets.get("timeline", use: getDiscoveryTimeline)
    }

    @Sendable
    func getOrphanPlanets(req: Request) async throws -> Response {
        do {
            let response = try await exoplanetService.fetchOrphanPlanets()
            return try Response(
                status: .ok,
                headers: ["Content-Type": "application/json"],
                body: .init(data: JSONEncoder().encode(response))
            )
        } catch {
            throw Abort(.notFound, reason: "No orphan planets found")
        }
    }

    @Sendable
    func getHottestExoplanet(req: Request) async throws -> Response {
        do {
            let response = try await exoplanetService.fetchHottestStarExoplanet()
            return try Response(
                status: .ok,
                headers: ["Content-Type": "application/json"],
                body: .init(data: JSONEncoder().encode(response))
            )
        } catch {
            throw Abort(.notFound, reason: "No hottest star exoplanet found")
        }
    }

    @Sendable
    func getDiscoveryTimeline(req: Request) async throws -> Response {
        do {
            let response = try await exoplanetService.fetchDiscoveryTimeline()
            return try Response(
                status: .ok,
                headers: ["Content-Type": "application/json"],
                body: .init(data: JSONEncoder().encode(response))
            )
        } catch {
            throw Abort(.notFound, reason: "No discovery timeline found")
        }
    }
}
