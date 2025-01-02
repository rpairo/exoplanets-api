import XCTest
@testable import App
@testable import ExoplanetsAPI

final class MapperTests: XCTestCase {
    func test_transformToLocalModel_withValidData_shouldReturnValidResponse() {
        let exoplanetDTO = ExoplanetDTO(
            planetIdentifier: "Exoplanet-1",
            typeFlag: 1,
            planetaryMassJpt: 0.5,
            radiusJpt: 1.2,
            periodDays: 365.25,
            semiMajorAxisAU: 1.0,
            eccentricity: "0.0167",
            periastronDeg: "114.20783",
            longitudeDeg: nil,
            ascendingNodeDeg: nil,
            inclinationDeg: 7.25,
            surfaceTempK: "5778",
            ageGyr: "4.6",
            discoveryMethod: "Radial Velocity",
            discoveryYear: 2020,
            lastUpdated: "2025-01-01",
            rightAscension: nil,
            declination: nil,
            distFromSunParsec: "10.5",
            hostStarMassSlrMass: 1.0,
            hostStarRadiusSlrRad: 1.0,
            hostStarMetallicity: 0.0,
            hostStarTempK: 5778,
            hostStarAgeGyr: "4.6"
        )
        let imageUrl = "https://example.com/image.jpg"

        let response = Mapper.transformToLocalModel(from: exoplanetDTO, imageUrl: imageUrl)

        XCTAssertEqual(response.planetIdentifier, "Exoplanet-1")
        XCTAssertEqual(response.typeFlag, 1)
        XCTAssertEqual(response.planetaryMassJpt, 0.5)
        XCTAssertEqual(response.radiusJpt, 1.2)
        XCTAssertEqual(response.periodDays, 365.25)
        XCTAssertEqual(response.semiMajorAxisAU, 1.0)
        XCTAssertEqual(response.eccentricity, "0.0167")
        XCTAssertEqual(response.periastronDeg, "114.20783")
        XCTAssertNil(response.longitudeDeg)
        XCTAssertEqual(response.inclinationDeg, 7.25)
        XCTAssertEqual(response.surfaceTempK, "5778")
        XCTAssertEqual(response.ageGyr, "4.6")
        XCTAssertEqual(response.discoveryMethod, "Radial Velocity")
        XCTAssertEqual(response.discoveryYear, 2020)
        XCTAssertEqual(response.lastUpdated, "2025-01-01")
        XCTAssertNil(response.rightAscension)
        XCTAssertNil(response.declination)
        XCTAssertEqual(response.distFromSunParsec, "10.5")
        XCTAssertEqual(response.hostStarMassSlrMass, 1.0)
        XCTAssertEqual(response.hostStarRadiusSlrRad, 1.0)
        XCTAssertEqual(response.hostStarMetallicity, 0.0)
        XCTAssertEqual(response.hostStarTempK, 5778)
        XCTAssertEqual(response.hostStarAgeGyr, "4.6")
        XCTAssertEqual(response.imageUrl, imageUrl)
    }

    func test_transformToLocalModel_withNilImageUrl_shouldReturnNilImageUrl() {
        let exoplanetDTO = ExoplanetDTO(
            planetIdentifier: "Exoplanet-1",
            typeFlag: 1,
            planetaryMassJpt: nil,
            radiusJpt: nil,
            periodDays: nil,
            semiMajorAxisAU: nil,
            eccentricity: nil,
            periastronDeg: nil,
            longitudeDeg: nil,
            ascendingNodeDeg: nil,
            inclinationDeg: nil,
            surfaceTempK: nil,
            ageGyr: nil,
            discoveryMethod: nil,
            discoveryYear: nil,
            lastUpdated: nil,
            rightAscension: nil,
            declination: nil,
            distFromSunParsec: nil,
            hostStarMassSlrMass: nil,
            hostStarRadiusSlrRad: nil,
            hostStarMetallicity: nil,
            hostStarTempK: nil,
            hostStarAgeGyr: nil
        )
        let imageUrl: String? = nil

        let response = Mapper.transformToLocalModel(from: exoplanetDTO, imageUrl: imageUrl)

        XCTAssertEqual(response.imageUrl, imageUrl)
    }

    func test_transformToLocalModel_withValidPlanetSizeCountDTO_shouldReturnValidResponse() {
        let planetSizeCountDTO = PlanetSizeCountDTO(small: 10, medium: 5, large: 2)

        let response = Mapper.transformToLocalModel(from: planetSizeCountDTO)

        XCTAssertEqual(response.small, 10)
        XCTAssertEqual(response.medium, 5)
        XCTAssertEqual(response.large, 2)
    }

    func test_transformToLocalModel_withZeroValues_shouldReturnValidResponse() {
        let planetSizeCountDTO = PlanetSizeCountDTO(small: 0, medium: 0, large: 0)

        let response = Mapper.transformToLocalModel(from: planetSizeCountDTO)

        XCTAssertEqual(response.small, 0)
        XCTAssertEqual(response.medium, 0)
        XCTAssertEqual(response.large, 0)
    }
}
