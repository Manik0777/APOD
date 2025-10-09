// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "Repository",
    platforms: [.iOS(.v18)],
    products: [.library(name: "Repository", targets: ["Repository"])],
    dependencies: [
        .package(path: "../Model"),
        .package(path: "../APIClient"),
        .package(path: "../../CoreModule/CoreUtils")
    ],
    targets: [
        .target(name: "Repository", dependencies: ["Model", "APIClient", "CoreUtils"], path: "Sources"),
        .testTarget(name: "RepositoryTests", dependencies: ["Repository"])
    ]
)
