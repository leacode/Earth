// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Earth",
    defaultLocalization: "en",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "Earth", targets: ["Earth"])
    ],
    targets: [
        .target(
            name: "Earth",
            resources: [.process("Resources")]
        )
    ],
    swiftLanguageVersions: [.v5]
)
