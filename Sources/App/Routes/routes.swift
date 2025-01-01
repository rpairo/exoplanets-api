import Vapor

func routes(_ app: Application) throws {
    let exoplanetService = ExoplanetService()

    let apiController = ExoplanetAPIController(exoplanetService: exoplanetService)
    try app.register(collection: apiController)

    let websiteController = ExoplanetWebsiteController(exoplanetService: exoplanetService)
    try app.register(collection: websiteController)

    app.get { req async throws -> View in
        try await req.view.render("Pages/index")
    }
}
