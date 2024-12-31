import Vapor
import ExoplanetAPI

func routes(_ app: Application) throws {
    app.get("orphans") { req async throws -> [VaporExoplanetDTO] in
        do {
            let analyzer = try await ExoplanetAnalyzerAPI()
            guard let orphans = analyzer.getOrphanPlanets() else {
                throw Abort(.notFound, reason: "No orphan planets found")
            }

            let orphanDTOs = orphans.map { Mapper.transformToLocalModel(from: $0) }
            return orphanDTOs
        } catch {
            throw Abort(.internalServerError, reason: error.localizedDescription)
        }
    }

    app.get("hottest") { req async throws -> VaporExoplanetDTO in
        do {
            let analyzer = try await ExoplanetAnalyzerAPI()
            guard let hottestExoplanet = analyzer.getHottestStarExoplanet() else {
                throw Abort(.notFound, reason: "No hottest star exoplanet found")
            }

            let result = Mapper.transformToLocalModel(from: hottestExoplanet)
            return result
        } catch {
            throw Abort(.internalServerError, reason: error.localizedDescription)
        }
    }

    app.get("timeline") { req async throws -> VaporYearlyPlanetSizeDistributionDTOResponse in
        do {
            let analyzer = try await ExoplanetAnalyzerAPI()
            guard let timeline = analyzer.getDiscoveryTimeline() else {
                throw Abort(.notFound, reason: "No discovery timeline found")
            }

            let sortedTimeline = timeline.sorted { $0.key < $1.key }

            let items = sortedTimeline.map { (year, planetSizeCount) in
                let size = Mapper.transformToLocalModel(from: planetSizeCount)
                return VaporYearlyPlanetSizeDistributionItemDTO(year: year, planetSizeCount: size)
            }

            let response = VaporYearlyPlanetSizeDistributionDTOResponse(data: items)
            return response
        } catch {
            throw Abort(.internalServerError, reason: error.localizedDescription)
        }
    }
}
