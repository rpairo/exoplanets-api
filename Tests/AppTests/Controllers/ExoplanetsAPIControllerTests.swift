import XCTest
import XCTVapor
@testable import App

final class ExoplanetsAPIControllerTests: XCTestCase {
    private var app: Application!
    private var mockExoplanetService: MockExoplanetService!

    override func setUp() async throws {
        app = try await Application.make(.testing)
        mockExoplanetService = MockExoplanetService()
        let controller = ExoplanetsAPIController(exoplanetService: mockExoplanetService)
        try app.register(collection: controller)
    }

    override func tearDown() async throws {
        try await app.asyncShutdown()
    }

    func test_getOrphanPlanets_withValidData_shouldReturnOrphanPlanets() async throws {
        mockExoplanetService.orphanPlanets = [
            ExoplanetResponse(planetIdentifier: "Orphan-1", typeFlag: 1, planetaryMassJpt: 0.5, radiusJpt: 1.2, periodDays: nil, semiMajorAxisAU: nil, eccentricity: nil, periastronDeg: nil, longitudeDeg: nil, ascendingNodeDeg: nil, inclinationDeg: nil, surfaceTempK: nil, ageGyr: nil, discoveryMethod: nil, discoveryYear: nil, lastUpdated: nil, rightAscension: nil, declination: nil, distFromSunParsec: nil, hostStarMassSlrMass: nil, hostStarRadiusSlrRad: nil, hostStarMetallicity: nil, hostStarTempK: nil, hostStarAgeGyr: nil, imageUrl: nil)
        ]

        try app.test(.GET, "api/orphans") { response in
            XCTAssertEqual(response.status, .ok)
            XCTAssertEqual(response.headers.contentType, .json)
            XCTAssertTrue(response.body.string.contains("Orphan-1"))
        }
    }

    func test_getOrphanPlanets_withNoData_shouldReturnNotFound() async throws {
        mockExoplanetService.orphanPlanets = []

        try app.test(.GET, "api/orphans") { response in
            XCTAssertEqual(response.status, .notFound)
            XCTAssertTrue(response.body.string.contains("No orphan planets found"))
        }
    }

    func test_getHottestExoplanet_withValidData_shouldReturnHottestExoplanet() async throws {
        mockExoplanetService.hottestExoplanet = ExoplanetResponse(planetIdentifier: "Hottest", typeFlag: 1, planetaryMassJpt: 1.0, radiusJpt: nil, periodDays: nil, semiMajorAxisAU: nil, eccentricity: nil, periastronDeg: nil, longitudeDeg: nil, ascendingNodeDeg: nil, inclinationDeg: nil, surfaceTempK: nil, ageGyr: nil, discoveryMethod: nil, discoveryYear: nil, lastUpdated: nil, rightAscension: nil, declination: nil, distFromSunParsec: nil, hostStarMassSlrMass: nil, hostStarRadiusSlrRad: nil, hostStarMetallicity: nil, hostStarTempK: nil, hostStarAgeGyr: nil, imageUrl: nil)

        try app.test(.GET, "api/hottest") { response in
            XCTAssertEqual(response.status, .ok)
            XCTAssertEqual(response.headers.contentType, .json)
            XCTAssertTrue(response.body.string.contains("Hottest"))
        }
    }

    func test_getHottestExoplanet_withNoData_shouldReturnNotFound() async throws {
        mockExoplanetService.hottestExoplanet = nil

        try app.test(.GET, "api/hottest") { response in
            XCTAssertEqual(response.status, .notFound)
            XCTAssertTrue(response.body.string.contains("No hottest star exoplanet found"))
        }
    }

    func test_getDiscoveryTimeline_withValidData_shouldReturnTimeline() async throws {
        mockExoplanetService.discoveryTimeline = YearlyPlanetSizeDistributionResponse(data: [
            YearlyPlanetSizeDistributionItemResponse(year: 2020, planetSizeCount: PlanetSizeCountResponse(small: 10, medium: 5, large: 2))
        ])

        try app.test(.GET, "api/timeline") { response in
            XCTAssertEqual(response.status, .ok)
            XCTAssertEqual(response.headers.contentType, .json)
            XCTAssertTrue(response.body.string.contains("2020"))
            XCTAssertTrue(response.body.string.contains("10"))
            XCTAssertTrue(response.body.string.contains("5"))
            XCTAssertTrue(response.body.string.contains("2"))
        }
    }

    func test_getDiscoveryTimeline_withNoData_shouldReturnNotFound() async throws {
        mockExoplanetService.discoveryTimeline = YearlyPlanetSizeDistributionResponse(data: [])

        try app.test(.GET, "api/timeline") { response in
            XCTAssertEqual(response.status, .notFound)
            XCTAssertTrue(response.body.string.contains("No discovery timeline found"))
        }
    }
}
