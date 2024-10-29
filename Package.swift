// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MMPopupView",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(name: "MMPopupView", targets: ["MMPopupView"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/Masonry.git", .upToNextMajor(from: "1.1.0")),
    ],
    targets: [
        .target(name: "MMPopupView", path: "Sources", exclude: []),
    ]
)
