import Vapor

func routes(_ app: Application) throws {
    let exoplanetService = ExoplanetService()
    let exoplanetController = ExoplanetController(exoplanetService: exoplanetService)

    try app.register(collection: exoplanetController)
}
