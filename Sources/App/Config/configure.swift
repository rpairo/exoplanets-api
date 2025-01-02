import Vapor
import Leaf

public func configure(_ app: Application) async throws {
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.views.use(.leaf)
    app.logger.logLevel = .debug
    try await routes(app)
}
