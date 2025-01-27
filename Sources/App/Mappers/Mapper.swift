import ExoplanetsAPI

struct Mapper {
    static func transformToLocalModel(from exoplanetDTO: ExoplanetDTO, imageUrl: String?) -> ExoplanetResponse {
        ExoplanetResponse(
            planetIdentifier: exoplanetDTO.planetIdentifier,
            typeFlag: exoplanetDTO.typeFlag,
            planetaryMassJpt: exoplanetDTO.planetaryMassJpt,
            radiusJpt: exoplanetDTO.radiusJpt,
            periodDays: exoplanetDTO.periodDays,
            semiMajorAxisAU: exoplanetDTO.semiMajorAxisAU,
            eccentricity: exoplanetDTO.eccentricity,
            periastronDeg: exoplanetDTO.periastronDeg,
            longitudeDeg: exoplanetDTO.longitudeDeg,
            ascendingNodeDeg: exoplanetDTO.ascendingNodeDeg,
            inclinationDeg: exoplanetDTO.inclinationDeg,
            surfaceTempK: exoplanetDTO.surfaceTempK,
            ageGyr: exoplanetDTO.ageGyr,
            discoveryMethod: exoplanetDTO.discoveryMethod,
            discoveryYear: exoplanetDTO.discoveryYear,
            lastUpdated: exoplanetDTO.lastUpdated,
            rightAscension: exoplanetDTO.rightAscension,
            declination: exoplanetDTO.declination,
            distFromSunParsec: exoplanetDTO.distFromSunParsec,
            hostStarMassSlrMass: exoplanetDTO.hostStarMassSlrMass,
            hostStarRadiusSlrRad: exoplanetDTO.hostStarRadiusSlrRad,
            hostStarMetallicity: exoplanetDTO.hostStarMetallicity,
            hostStarTempK: exoplanetDTO.hostStarTempK,
            hostStarAgeGyr: exoplanetDTO.hostStarAgeGyr,
            imageUrl: imageUrl
        )
    }

    static func transformToLocalModel(from planetSizeCountDTO: PlanetSizeCountDTO) -> PlanetSizeCountResponse {
        PlanetSizeCountResponse(
            small: planetSizeCountDTO.small,
            medium: planetSizeCountDTO.medium,
            large: planetSizeCountDTO.large
        )
    }
}
