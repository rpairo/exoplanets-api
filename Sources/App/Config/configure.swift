import Vapor
import Leaf

public func configure(_ app: Application) throws {
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.views.use(.leaf)
    app.logger.logLevel = .debug
    try routes(app)
}
