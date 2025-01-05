import Vapor

struct NotFoundMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        do {
            return try await next.respond(to: request)
        } catch let abort as AbortError where abort.status == .notFound {
            throw Abort(.notFound, reason: "The requested route does not exist.")
        } catch let abort as AbortError {
            throw Abort(abort.status, reason: abort.reason)
        } catch {
            throw Abort(.internalServerError, reason: "An unexpected error occurred.")
        }
    }
}
