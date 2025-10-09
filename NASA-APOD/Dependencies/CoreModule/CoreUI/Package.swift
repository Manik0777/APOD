// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "CoreUI",
    platforms: [.iOS(.v18)],
    products: [.library(name: "CoreUI", targets: ["CoreUI"])],
    dependencies: [],
    targets: [
        .target(name: "CoreUI", path: "Sources"),
        .testTarget(name: "CoreUITests", dependencies: ["CoreUI"])
    ]
)
