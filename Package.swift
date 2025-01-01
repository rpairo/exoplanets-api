// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ExoplanetsAPI",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        // Dependencia de Vapor
        .package(url: "https://github.com/vapor/vapor.git", from: "4.110.1"),
        // Dependencia de Swift NIO
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
        // Dependencia de Exoplanets
        .package(url: "https://github.com/rpairo/exoplanets.git", from: "1.0.5"),
        // Dependencia de Leaf
        .package(url: "https://github.com/vapor/leaf.git", from: "4.0.0")
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                // Productos de Vapor
                .product(name: "Vapor", package: "vapor"),
                // Productos de Swift NIO
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                // Producto de Exoplanets
                .product(name: "ExoplanetAPI", package: "exoplanets"),
                // Producto de Leaf
                .product(name: "Leaf", package: "leaf")
            ],
            resources: [
                // Copiar la carpeta Resources
                .copy("Resources")
            ],
            swiftSettings: [
                // Configuraciones de Swift
                .unsafeFlags(["-enable-experimental-concurrency"], .when(configuration: .release))
            ]
        ),
        .testTarget(
            name: "AppTests",
            dependencies: [
                .target(name: "App"),
                // Producto de Vapor para pruebas
                .product(name: "XCTVapor", package: "vapor")
            ]
        )
    ]
)
