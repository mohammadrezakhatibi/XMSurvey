// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Feature",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        // Core
        .library(name: "HTTPClient", targets: ["HTTPClient"]),
        .library(name: "Models", targets: ["Models"]),
        .library(name: "Shared", targets: ["Shared"]),
    ],
    targets: [
        .target(name: "HTTPClient"),
        .target(name: "Models"),
        .target(name: "Shared"),
        //.testTarget(name: "FeatureTests", dependencies: ["Feature"]),
    ]
)
