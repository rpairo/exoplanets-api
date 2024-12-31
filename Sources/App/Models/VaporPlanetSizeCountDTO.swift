import Vapor

public struct VaporPlanetSizeCountDTO: Content {
    public let smallPlanets: Int
    public let mediumPlanets: Int
    public let largePlanets: Int

    public init(smallPlanets: Int, mediumPlanets: Int, largePlanets: Int) {
        self.smallPlanets = smallPlanets
        self.mediumPlanets = mediumPlanets
        self.largePlanets = largePlanets
    }
}
