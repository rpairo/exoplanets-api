import Vapor

public struct VaporYearlyPlanetSizeDistributionItemDTO: Content {
    public let year: Int
    public let planetSizeCount: VaporPlanetSizeCountDTO

    public init(year: Int, planetSizeCount: VaporPlanetSizeCountDTO) {
        self.year = year
        self.planetSizeCount = planetSizeCount
    }
}

public struct VaporYearlyPlanetSizeDistributionDTOResponse: Content {
    public let data: [VaporYearlyPlanetSizeDistributionItemDTO]

    public init(data: [VaporYearlyPlanetSizeDistributionItemDTO]) {
        self.data = data
    }
}
