import Vapor

public func configure(_ app: Application) async throws {
    try await routes(app)
}
