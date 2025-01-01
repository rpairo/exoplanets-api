import Vapor

struct RootController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get(use: renderHomePage)

        let website = routes.grouped("website")
        website.get(use: renderHomePage)
    }

    func renderHomePage(req: Request) async throws -> View {
        // Renderiza la misma vista para ambas rutas
        try await req.view.render("Pages/index")
    }
}
