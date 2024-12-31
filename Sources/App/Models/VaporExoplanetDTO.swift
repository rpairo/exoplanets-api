import Vapor

public struct VaporExoplanetDTO: Content {
    public let planetIdentifier: String?
    public let typeFlag: Int?
    public let planetaryMassJpt: Double?
    public let radiusJpt: Double?
    public let periodDays: Double?
    public let semiMajorAxisAU: Double?
    public let eccentricity: String?
    public let periastronDeg: String?
    public let longitudeDeg: String?
    public let ascendingNodeDeg: String?
    public let inclinationDeg: Double?
    public let surfaceTempK: String?
    public let ageGyr: String?
    public let discoveryMethod: String?
    public let discoveryYear: Int?
    public let lastUpdated: String?
    public let rightAscension: String?
    public let declination: String?
    public let distFromSunParsec: String?
    public let hostStarMassSlrMass: Double?
    public let hostStarRadiusSlrRad: Double?
    public let hostStarMetallicity: Double?
    public let hostStarTempK: Int?
    public let hostStarAgeGyr: String?
}
