import Vapor
import ExoplanetAPI

public struct VaporExoplanetDTODos: Content {
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

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    app.get("orphans") { req async throws -> [VaporExoplanetDTO] in
        do {
            let analyzer = try await ExoplanetAnalyzerAPI()
            guard let orphans = analyzer.getOrphanPlanets() else {
                throw Abort(.notFound, reason: "No orphan planets found")
            }

            // Map ExoplanetDTO to VaporExoplanetDTO
            let orphanDTOs = orphans.map { transformToLocalModel(from: $0) }
            return orphanDTOs
        } catch {
            throw Abort(.internalServerError, reason: error.localizedDescription)
        }
    }

    // Endpoint to get hottest exoplanet
    app.get("hottest") { req async throws -> VaporExoplanetDTO in
        do {
            let analyzer = try await ExoplanetAnalyzerAPI()
            guard let hottestExoplanet = analyzer.getHottestStarExoplanet() else {
                throw Abort(.notFound, reason: "No hottest star exoplanet found")
            }

            let result = transformToLocalModel(from: hottestExoplanet)
            return result
        } catch {
            throw Abort(.internalServerError, reason: error.localizedDescription)
        }
    }

    // Endpoint to get discovery timeline
    app.get("timeline") { req async throws -> VaporYearlyPlanetSizeDistributionDTOResponse in
        do {
            let analyzer = try await ExoplanetAnalyzerAPI()
            guard let timeline = analyzer.getDiscoveryTimeline() else {
                throw Abort(.notFound, reason: "No discovery timeline found")
            }

            // Convert the dictionary to a sorted list of items by year
            let sortedTimeline = timeline.sorted { $0.key < $1.key }

            // Map to the desired response format
            let items = sortedTimeline.map { (year, planetSizeCount) in
                let size = transformToLocalModel(from: planetSizeCount)
                return VaporYearlyPlanetSizeDistributionItemDTO(year: year, planetSizeCount: size)
            }

            let response = VaporYearlyPlanetSizeDistributionDTOResponse(data: items)
            return response
        } catch {
            throw Abort(.internalServerError, reason: error.localizedDescription)
        }
    }

    @Sendable func transformToLocalModel(from exoplanetDTO: ExoplanetDTO) -> VaporExoplanetDTO {
        return VaporExoplanetDTO(
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
            hostStarAgeGyr: exoplanetDTO.hostStarAgeGyr
        )
    }

    @Sendable func transformToLocalModel(from planetSizeCountDTO: PlanetSizeCountDTO) -> VaporPlanetSizeCountDTO {
        return VaporPlanetSizeCountDTO(
            smallPlanets: planetSizeCountDTO.smallPlanets,
            mediumPlanets: planetSizeCountDTO.mediumPlanets,
            largePlanets: planetSizeCountDTO.largePlanets
        )
    }
}
