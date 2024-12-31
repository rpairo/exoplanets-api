import Vapor

struct PlanetSizeCountResponse: Content {
    let small: Int
    let medium: Int
    let large: Int
}
