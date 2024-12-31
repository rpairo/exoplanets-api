import Vapor
@preconcurrency import ExoplanetAPI

// MARK: - Routes
func routes(_ app: Application) async throws {
    let exoplanetController = await ExoplanetController(exoplanetService: .init(analyzer: try .init()))

    // Define routes
    app.get("orphans", use: exoplanetController.getOrphanPlanets)
    app.get("hottest", use: exoplanetController.getHottestExoplanet)
    app.get("timeline", use: exoplanetController.getDiscoveryTimeline)
}

// MARK: - Controller

struct ExoplanetController: Sendable {
    private let exoplanetService: ExoplanetService

    init(exoplanetService: ExoplanetService) {
        self.exoplanetService = exoplanetService
    }

    // Get orphan planets
    @Sendable
    func getOrphanPlanets(req: Request) async throws -> [VaporExoplanetDTO] {
        do {
            let orphans = try await exoplanetService.fetchOrphanPlanets()
            return orphans.map { Mapper.transformToLocalModel(from: $0) }
        } catch {
            throw Abort(.notFound, reason: "No orphan planets found")
        }
    }

    // Get the hottest star exoplanet
    @Sendable
    func getHottestExoplanet(req: Request) async throws -> VaporExoplanetDTO {
        do {
            let hottestExoplanet = try await exoplanetService.fetchHottestStarExoplanet()
            return Mapper.transformToLocalModel(from: hottestExoplanet)
        } catch {
            throw Abort(.notFound, reason: "No hottest star exoplanet found")
        }
    }

    // Get discovery timeline
    @Sendable
    func getDiscoveryTimeline(req: Request) async throws -> VaporYearlyPlanetSizeDistributionDTOResponse {
        do {
            let timeline = try await exoplanetService.fetchDiscoveryTimeline()
            let sortedTimeline = timeline.sorted { $0.key < $1.key }

            let items = sortedTimeline.map { (year, planetSizeCount) in
                let size = Mapper.transformToLocalModel(from: planetSizeCount)
                return VaporYearlyPlanetSizeDistributionItemDTO(year: year, planetSizeCount: size)
            }

            return VaporYearlyPlanetSizeDistributionDTOResponse(data: items)
        } catch {
            throw Abort(.notFound, reason: "No discovery timeline found")
        }
    }
}

// MARK: - Service Layer

struct ExoplanetService: Sendable {
    private let analyzer: ExoplanetAnalyzerAPI

    init(analyzer: ExoplanetAnalyzerAPI) {
        self.analyzer = analyzer
    }

    // Fetch orphan planets
    func fetchOrphanPlanets() async throws -> [ExoplanetDTO] {
        guard let orphans = analyzer.getOrphanPlanets() else {
            throw Abort(.notFound, reason: "No orphan planets found")
        }
        return orphans
    }

    // Fetch the hottest star exoplanet
    func fetchHottestStarExoplanet() async throws -> ExoplanetDTO {
        guard let hottestExoplanet = analyzer.getHottestStarExoplanet() else {
            throw Abort(.notFound, reason: "No hottest star exoplanet found")
        }
        return hottestExoplanet
    }

    // Fetch the discovery timeline
    func fetchDiscoveryTimeline() async throws -> YearlyPlanetSizeDistributionDTO {
        guard let timeline = analyzer.getDiscoveryTimeline() else {
            throw Abort(.notFound, reason: "No discovery timeline found")
        }
        return timeline
    }
}
