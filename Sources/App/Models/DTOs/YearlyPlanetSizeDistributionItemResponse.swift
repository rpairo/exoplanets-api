import Vapor

struct YearlyPlanetSizeDistributionItemResponse: Content {
    let year: Int
    let planetSizeCount: PlanetSizeCountResponse
}

struct YearlyPlanetSizeDistributionResponse: Content {
    let data: [YearlyPlanetSizeDistributionItemResponse]
}
