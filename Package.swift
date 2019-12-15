// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "WolfColor",
    platforms: [
        .iOS(.v9), .macOS(.v10_13), .tvOS(.v11)
    ],
    products: [
        .library(
            name: "WolfColor",
            type: .dynamic,
            targets: ["WolfColor"]),
        ],
    dependencies: [
        .package(url: "https://github.com/wolfmcnally/WolfNumerics", from: "4.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfOSBridge", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfPipe", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfFoundation", from: "5.0.0"),
    ],
    targets: [
        .target(
            name: "WolfColor",
            dependencies: [
                "WolfNumerics",
                "WolfOSBridge",
                "WolfPipe",
                "WolfFoundation"
        ])
        ]
)
