// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ShadcnSwiftUI",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
    ],
    products: [
        .library(name: "ShadcnSwiftUI", targets: ["ShadcnSwiftUI"]),
    ],
    targets: [
        .target(name: "ShadcnSwiftUI", path: "Sources/ShadcnSwiftUI"),
        .testTarget(name: "ShadcnSwiftUITests", dependencies: ["ShadcnSwiftUI"], path: "Tests/ShadcnSwiftUITests"),
    ]
)
