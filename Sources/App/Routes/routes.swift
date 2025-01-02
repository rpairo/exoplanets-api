import Vapor

func routes(_ app: Application) throws {
    let appConfig = AppConfig()

    let rootController = RootController()
    try app.register(collection: rootController)
    
    let imageService = GoogleImageService(client: app.client, config: appConfig)
    let exoplanetService = ExoplanetService(client: app.client, imageService: imageService)

    let apiController = ExoplanetsAPIController(exoplanetService: exoplanetService)
    try app.register(collection: apiController)

    let websiteController = ExoplanetWebsiteController(exoplanetService: exoplanetService)
    try app.register(collection: websiteController)
}
