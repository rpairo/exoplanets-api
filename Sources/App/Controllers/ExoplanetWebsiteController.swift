import Vapor

struct ExoplanetWebsiteController: RouteCollection, Sendable {
    private let exoplanetService: ExoplanetAnalyzerServiceable

    init(exoplanetService: ExoplanetAnalyzerServiceable) {
        self.exoplanetService = exoplanetService
    }

    func boot(routes: RoutesBuilder) throws {
        routes.get(use: renderHomePage)

        let website = routes.grouped("website")
        website.get(use: renderHomePage)

        website.get("orphans", use: showOrphanPlanets)
        website.get("hottest", use: showHottestExoplanet)
        website.get("timeline", use: showDiscoveryTimeline)
    }

    @Sendable
    func showOrphanPlanets(req: Request) async throws -> View {
        let orphanPlanets = try await exoplanetService.fetchOrphanPlanets()
        return try await req.view.render("Pages/orphans", ["planets": orphanPlanets])
    }

    @Sendable
    func showHottestExoplanet(req: Request) async throws -> View {
        let hottestExoplanet = try await exoplanetService.fetchHottestStarExoplanet()
        return try await req.view.render("Pages/hottest", ["planet": hottestExoplanet])
    }

    @Sendable
    func showDiscoveryTimeline(req: Request) async throws -> View {
        let timeline = try await exoplanetService.fetchDiscoveryTimeline()
        return try await req.view.render("Pages/timeline", ["timeline": timeline])
    }

    @Sendable
    func renderHomePage(req: Request) async throws -> View {
        try await req.view.render("Pages/index")
    }
}
