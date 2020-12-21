// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "WolfColor",
    platforms: [
        .iOS(.v9), .macOS(.v10_13), .tvOS(.v11)
    ],
    products: [
        .library(
            name: "WolfColor",
            targets: ["WolfColor"]),
    ],
    dependencies: [
        .package(url: "https://github.com/wolfmcnally/Interpolate", from: "0.0.0")
    ],
    targets: [
        .target(
            name: "WolfColor",
            dependencies: [
                "Interpolate",
            ])
    ]
)
