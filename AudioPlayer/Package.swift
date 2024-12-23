// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AudioPlayer",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "AudioPlayer", targets: [
            "AudioPlayer"
        ]),
        .library(name: "AudioPlayerClient", targets: [
            "AudioPlayerClient"
        ]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-nonempty", from: "0.5.0")
    ],
    targets: [
        .target(name: "AudioPlayer", dependencies: [
            .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            .product(name: "NonEmpty", package: "swift-nonempty"),
            .target(name: "AudioPlayerClient")
        ]),
        .target(name: "AudioPlayerClient", dependencies: [
            .product(name: "Dependencies", package: "swift-dependencies"),
            .product(name: "DependenciesMacros", package: "swift-dependencies")
        ]),
        .testTarget(name: "AudioPlayerTests", dependencies: [
            .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            .target(name: "AudioPlayer"),
            .target(name: "AudioPlayerClient")
        ])
    ]
)
