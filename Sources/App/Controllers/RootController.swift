import Vapor

struct RootController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get(use: renderHomePage)

        let website = routes.grouped("website")
        website.get(use: renderHomePage)
    }

    func renderHomePage(req: Request) async throws -> View {
        try await req.view.render("Pages/index")
    }
}
