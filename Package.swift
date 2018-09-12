// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Earth",
    products: [
        .library(name: "Earth", targets: ["Earth"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Earth", dependencies: []),
    ]
)
