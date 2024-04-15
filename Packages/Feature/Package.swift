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
        
        // Features
        .library(name: "Survey", targets: ["Survey"]),
        .library(name: "Home", targets: ["Home"]),
        .library(name: "App", targets: ["App"]),
        
        // Test
        .library(name: "TestHelpers", targets: ["TestHelpers"]),
    ],
    targets: [
        // Core
        .target(name: "HTTPClient"),
        .target(name: "Models"),
        .target(name: "Shared"),
        .target(name: "TestHelpers", path: "Tests/TestHelpers"),
        
        // Features
        .target(name: "Survey", dependencies: ["Models", "HTTPClient", "Shared"]),
        .target(name: "Home", dependencies: ["Models", "HTTPClient"]),
        .target(name: "App", dependencies: ["Home", "Survey"]),
        
        
        
        .testTarget(name: "SurveyTests", dependencies: ["Survey", "TestHelpers"]),
    ]
)
