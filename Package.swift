// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Polymorph",
    platforms: [
        .visionOS(.v1),
        .iOS(.v15),
    ],
    products: [
        .library(name: "Polymorph", targets: ["Polymorph"])
    ],
    targets: [
        .target(name: "Polymorph"),
        .testTarget(name: "PolymorphTests", dependencies: ["Polymorph"]),
    ]
)
