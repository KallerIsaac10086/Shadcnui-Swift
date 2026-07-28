// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ShadcnSwift",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
    ],
    products: [
        .library(name: "ShadcnSwift", targets: ["ShadcnSwift"]),
    ],
    targets: [
        .target(name: "ShadcnSwift", path: "Sources/ShadcnSwift"),
        .testTarget(name: "ShadcnSwiftTests", dependencies: ["ShadcnSwift"], path: "Tests/ShadcnSwiftTests"),
    ]
)
