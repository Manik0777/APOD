// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Explore",
    defaultLocalization: "en",
    platforms: [.iOS(.v18)],
    products: [.library(name: "Explore", targets: ["Explore"])],
    dependencies: [
        .package(path: "../../../CoreModule/CoreUI"),
        .package(path: "../../../DataModule/Repository"),
        .package(path: "../../../DataModule/Model")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Explore",
            dependencies: [
                "CoreUI",
                "Repository",
                "Model",
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "ExploreTests",
            dependencies: ["Explore"]),
    ]
    
)
