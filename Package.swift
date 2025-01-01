// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ExoplanetsAPI",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "App", targets: ["App"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.110.1"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
        .package(url: "https://github.com/rpairo/exoplanets.git", from: "1.0.10"),
        .package(url: "https://github.com/vapor/leaf.git", from: "4.0.0")
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "ExoplanetsAPI", package: "exoplanets"),
                .product(name: "Leaf", package: "leaf")
            ],
            resources: [
                .copy("Resources")
            ]
        ),
        .testTarget(
            name: "AppTests",
            dependencies: [
                .target(name: "App"),
                .product(name: "XCTVapor", package: "vapor")
            ]
        )
    ]
)
