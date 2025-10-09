// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "APIClient",
    platforms: [.iOS(.v18)],
    products: [.library(name: "APIClient", targets: ["APIClient"])],
    dependencies: [
        .package(path: "../Model"),
        .package(path: "../../CoreModule/CoreUtils")
    ],
    targets: [
        .target(name: "APIClient", dependencies: ["Model", "CoreUtils"], path: "Sources"),
        .testTarget(name: "APIClientTests", dependencies: ["APIClient"])
    ]
)
