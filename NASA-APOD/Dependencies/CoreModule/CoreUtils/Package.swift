// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "CoreUtils",
    platforms: [.iOS(.v18)],
    products: [.library(name: "CoreUtils", targets: ["CoreUtils"])],
    targets: [
        .target(name: "CoreUtils", path: "Sources"),
        .testTarget(name: "CoreUtilsTests", dependencies: ["CoreUtils"])
    ]
)
