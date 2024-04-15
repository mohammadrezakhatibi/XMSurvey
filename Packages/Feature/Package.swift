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
        .library(name: "HTTPClient", targets: ["HTTPClient"]),
    ],
    targets: [
        .target(name: "HTTPClient"),
        //.testTarget(name: "FeatureTests", dependencies: ["Feature"]),
    ]
)
