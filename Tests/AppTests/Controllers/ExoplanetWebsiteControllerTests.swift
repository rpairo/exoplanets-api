import XCTVapor
@testable import App

final class ExoplanetWebsiteControllerTests: XCTestCase {
    private var app: Application!
    private var mockExoplanetService: MockExoplanetService!

    override func setUp() async throws {
        app = try await Application.make(.testing)
        mockExoplanetService = MockExoplanetService()
        let controller = ExoplanetWebsiteController(exoplanetService: mockExoplanetService)
        try app.register(collection: controller)
        app.views.use { _ in TestViewRenderer() }
    }

    override func tearDown() async throws {
        try await app.asyncShutdown()
    }

    // MARK: - Tests
    func test_renderHomePage_shouldRenderIndexPage() async throws {
        try app.test(.GET, "") { response in
            XCTAssertEqual(response.status, .ok)
            XCTAssertTrue(response.body.string.contains("Pages/index"), "La página de inicio debe renderizar correctamente.")
        }
    }

    func test_renderHomePage_underWebsite_shouldRenderIndexPage() async throws {
        try app.test(.GET, "website") { response in
            XCTAssertEqual(response.status, .ok)
            XCTAssertTrue(response.body.string.contains("Pages/index"), "La página de inicio debe renderizar correctamente desde /website.")
        }
    }

    func test_showOrphanPlanets_withValidData_shouldRenderOrphansPage() async throws {
        mockExoplanetService.orphanPlanets = [
            ExoplanetResponse(planetIdentifier: "Orphan-1", typeFlag: 1, planetaryMassJpt: 0.5, radiusJpt: 1.2, periodDays: nil, semiMajorAxisAU: nil, eccentricity: nil, periastronDeg: nil, longitudeDeg: nil, ascendingNodeDeg: nil, inclinationDeg: nil, surfaceTempK: nil, ageGyr: nil, discoveryMethod: nil, discoveryYear: nil, lastUpdated: nil, rightAscension: nil, declination: nil, distFromSunParsec: nil, hostStarMassSlrMass: nil, hostStarRadiusSlrRad: nil, hostStarMetallicity: nil, hostStarTempK: nil, hostStarAgeGyr: nil, imageUrl: nil)
        ]

        try app.test(.GET, "website/orphans") { response in
            XCTAssertEqual(response.status, .ok)
            XCTAssertTrue(response.body.string.contains("Pages/orphans"), "La página de planetas huérfanos debe renderizar correctamente.")
        }
    }

    func test_showOrphanPlanets_withNoData_shouldReturnNotFound() async throws {
        mockExoplanetService.orphanPlanets = nil

        try app.test(.GET, "website/orphans") { response in
            XCTAssertEqual(response.status, .notFound)
            XCTAssertTrue(response.body.string.contains("No orphan planets found"), "La respuesta debe indicar que no se encontraron planetas huérfanos.")
        }
    }

    func test_showHottestExoplanet_withValidData_shouldRenderHottestPage() async throws {
        mockExoplanetService.hottestExoplanet = ExoplanetResponse(planetIdentifier: "Hottest", typeFlag: 1, planetaryMassJpt: 0.5, radiusJpt: nil, periodDays: nil, semiMajorAxisAU: nil, eccentricity: nil, periastronDeg: nil, longitudeDeg: nil, ascendingNodeDeg: nil, inclinationDeg: nil, surfaceTempK: nil, ageGyr: nil, discoveryMethod: nil, discoveryYear: nil, lastUpdated: nil, rightAscension: nil, declination: nil, distFromSunParsec: nil, hostStarMassSlrMass: nil, hostStarRadiusSlrRad: nil, hostStarMetallicity: nil, hostStarTempK: nil, hostStarAgeGyr: nil, imageUrl: nil)

        try app.test(.GET, "website/hottest") { response in
            XCTAssertEqual(response.status, .ok)
            XCTAssertTrue(response.body.string.contains("Pages/hottest"), "La página del exoplaneta más caliente debe renderizar correctamente.")
        }
    }

    func test_showDiscoveryTimeline_withValidData_shouldRenderTimelinePage() async throws {
        mockExoplanetService.discoveryTimeline = YearlyPlanetSizeDistributionResponse(data: [
            YearlyPlanetSizeDistributionItemResponse(year: 2020, planetSizeCount: PlanetSizeCountResponse(small: 10, medium: 5, large: 2))
        ])

        try app.test(.GET, "website/timeline") { response in
            XCTAssertEqual(response.status, .ok)
            XCTAssertTrue(response.body.string.contains("Pages/timeline"), "La página de la línea de tiempo debe renderizar correctamente.")
        }
    }

    func test_showDiscoveryTimeline_withNoData_shouldReturnNotFound() async throws {
        mockExoplanetService.discoveryTimeline = nil

        // Act
        try app.test(.GET, "website/timeline") { response in
            XCTAssertEqual(response.status, .notFound)
            XCTAssertTrue(response.body.string.contains("No discovery timeline found"), "La respuesta debe indicar que no se encontró una línea de tiempo.")
        }
    }
}
