import Vapor

func routes(_ app: Application) async throws {
    let exoplanetController = ExoplanetController(exoplanetService: ExoplanetService())

    app.get("orphans", use: exoplanetController.getOrphanPlanets)
    app.get("hottest", use: exoplanetController.getHottestExoplanet)
    app.get("timeline", use: exoplanetController.getDiscoveryTimeline)
}
