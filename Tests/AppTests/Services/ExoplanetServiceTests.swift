import XCTVapor
@testable import ExoplanetsAPI
@testable import App

final class ExoplanetServiceTests: XCTestCase {
    private var mockClient: MockClient!
    private var mockImageService: MockImageSearchService!
    private var mockAnalyzerAPI: MockExoplanetAnalyzerAPI!
    private var service: ExoplanetService!

    override func setUp() {
        super.setUp()
        mockClient = MockClient(eventLoop: EmbeddedEventLoop())
        mockImageService = MockImageSearchService()
        mockAnalyzerAPI = MockExoplanetAnalyzerAPI()
        service = ExoplanetService(client: mockClient, imageService: mockImageService, analyzer: mockAnalyzerAPI)
    }

    override func tearDown() {
        mockClient = nil
        mockImageService = nil
        mockAnalyzerAPI = nil
        service = nil
        super.tearDown()
    }

    // MARK: - Tests
    func test_fetchOrphanPlanets_withValidData_shouldReturnPlanets() async throws {
        let mockPlanet = [ExoplanetDTO(planetIdentifier: "Orphan1", typeFlag: 3, planetaryMassJpt: nil, radiusJpt: nil, periodDays: nil, semiMajorAxisAU: nil, eccentricity: nil, periastronDeg: nil, longitudeDeg: nil, ascendingNodeDeg: nil, inclinationDeg: nil, surfaceTempK: nil, ageGyr: nil, discoveryMethod: nil, discoveryYear: nil, lastUpdated: nil, rightAscension: nil, declination: nil, distFromSunParsec: nil, hostStarMassSlrMass: nil, hostStarRadiusSlrRad: nil, hostStarMetallicity: nil, hostStarTempK: nil, hostStarAgeGyr: nil)]
        mockAnalyzerAPI.mockOrphanPlanets = mockPlanet
        mockImageService.mockImageURL = "https://example.com/image.jpg"

        let result = try await service.fetchOrphanPlanets()

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.planetIdentifier, "Orphan1")
    }

    func test_fetchOrphanPlanets_withNoData_shouldThrowNotFound() async {
        mockAnalyzerAPI.mockOrphanPlanets = nil

        do {
            _ = try await service.fetchOrphanPlanets()
            XCTFail("Expected error to be thrown, but no error was thrown.")
        } catch {
            XCTAssertTrue(error is Abort)
            XCTAssertEqual((error as? Abort)?.reason, "No orphan planets found")
        }
    }

    func test_fetchHottestStarExoplanet_withValidData_shouldReturnExoplanet() async throws {
        let mockHottestExoplanet = ExoplanetDTO(planetIdentifier: "Hottest", typeFlag: 1, planetaryMassJpt: nil, radiusJpt: nil, periodDays: nil, semiMajorAxisAU: nil, eccentricity: nil, periastronDeg: nil, longitudeDeg: nil, ascendingNodeDeg: nil, inclinationDeg: nil, surfaceTempK: nil, ageGyr: nil, discoveryMethod: nil, discoveryYear: nil, lastUpdated: nil, rightAscension: nil, declination: nil, distFromSunParsec: nil, hostStarMassSlrMass: nil, hostStarRadiusSlrRad: nil, hostStarMetallicity: nil, hostStarTempK: nil, hostStarAgeGyr: nil)
        mockAnalyzerAPI.mockHottestExoplanet = mockHottestExoplanet
        mockImageService.mockImageURL = "https://example.com/image.jpg"

        let result = try await service.fetchHottestStarExoplanet()

        XCTAssertEqual(result.planetIdentifier, "Hottest")
        XCTAssertEqual(result.imageUrl, "https://example.com/image.jpg")
    }

    func test_fetchHottestStarExoplanet_withNoData_shouldThrowNotFound() async {
        mockAnalyzerAPI.mockHottestExoplanet = nil

        do {
            _ = try await service.fetchHottestStarExoplanet()
            XCTFail("Expected error to be thrown, but no error was thrown.")
        } catch {
            XCTAssertTrue(error is Abort)
            XCTAssertEqual((error as? Abort)?.reason, "No hottest star exoplanet found")
        }
    }

    func test_fetchDiscoveryTimeline_withValidData_shouldReturnTimeline() async throws {
        let mockTimeline: YearlyPlanetSizeDistributionDTO = [
            2020: PlanetSizeCountDTO(small: 10, medium: 5, large: 2)
        ]
        mockAnalyzerAPI.mockDiscoveryTimeline = mockTimeline

        let result = try await service.fetchDiscoveryTimeline()

        XCTAssertEqual(result.data.count, 1)
        XCTAssertEqual(result.data.first?.year, 2020)
        XCTAssertEqual(result.data.first?.planetSizeCount.small, 10)
        XCTAssertEqual(result.data.first?.planetSizeCount.medium, 5)
        XCTAssertEqual(result.data.first?.planetSizeCount.large, 2)
    }

    func test_fetchDiscoveryTimeline_withNoData_shouldThrowNotFound() async {
        mockAnalyzerAPI.mockDiscoveryTimeline = nil

        do {
            _ = try await service.fetchDiscoveryTimeline()
            XCTFail("Expected error to be thrown, but no error was thrown.")
        } catch {
            XCTAssertTrue(error is Abort)
            XCTAssertEqual((error as? Abort)?.reason, "No discovery timeline found")
        }
    }
}
