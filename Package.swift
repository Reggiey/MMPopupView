// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MMPopupView",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "MMPopupView", targets: ["MMPopupView"]),
    ],
    targets: [
        .target(name: "MMPopupView", path: "Sources", exclude: []),
    ]
)
