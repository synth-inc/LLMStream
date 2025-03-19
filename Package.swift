// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MarkdownLatex",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "MarkdownLatex",
            targets: ["MarkdownLatex"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MarkdownLatex",
            dependencies: [],
            resources: [.process("Renderer.js")] // Inclure le script JS
        ),
        .testTarget(
            name: "MarkdownLatexTests",
            dependencies: ["MarkdownLatex"]
        ),
    ]
)