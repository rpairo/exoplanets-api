import Vapor

struct ExoplanetResponse: Content {
    let planetIdentifier: String?
    let typeFlag: Int?
    let planetaryMassJpt: Double?
    let radiusJpt: Double?
    let periodDays: Double?
    let semiMajorAxisAU: Double?
    let eccentricity: String?
    let periastronDeg: String?
    let longitudeDeg: String?
    let ascendingNodeDeg: String?
    let inclinationDeg: Double?
    let surfaceTempK: String?
    let ageGyr: String?
    let discoveryMethod: String?
    let discoveryYear: Int?
    let lastUpdated: String?
    let rightAscension: String?
    let declination: String?
    let distFromSunParsec: String?
    let hostStarMassSlrMass: Double?
    let hostStarRadiusSlrRad: Double?
    let hostStarMetallicity: Double?
    let hostStarTempK: Int?
    let hostStarAgeGyr: String?
    let imageUrl: String?
}
