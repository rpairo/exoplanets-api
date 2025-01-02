import Vapor
import ExoplanetsAPI

func routes(_ app: Application) async throws {
    let appConfig = try AppConfig()

    let analyzer = try await ExoplanetAnalyzerAPI.makeDefault()
    let imageService = GoogleImageService(client: app.client, config: appConfig)
    let exoplanetService = ExoplanetService(client: app.client, imageService: imageService, analyzer: analyzer)

    let apiController = ExoplanetsAPIController(exoplanetService: exoplanetService)
    try app.register(collection: apiController)

    let websiteController = ExoplanetWebsiteController(exoplanetService: exoplanetService)
    try app.register(collection: websiteController)
}
