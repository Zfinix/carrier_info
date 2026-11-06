// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "carrier_info",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "carrier-info", targets: ["carrier_info"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "carrier_info",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)
