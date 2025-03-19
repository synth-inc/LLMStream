// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LLMStream",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "LLMStream",
            targets: ["LLMStream"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "LLMStream",
            dependencies: [],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "LLMStreamTests",
            dependencies: ["LLMStream"]
        ),
    ]
)
