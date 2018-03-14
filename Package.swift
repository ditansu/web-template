// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "webapp",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0-rc"),
        .package(url: "https://github.com/vapor/mysql-driver.git", from: "3.0.0-rc"),
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.0-rc"),
        .package(url: "https://github.com/crossroadlabs/Markdown.git", .exact("1.0.0-alpha.2")),
        .package(url: "https://github.com/twostraws/SwiftSlug.git", .upToNextMinor(from: "0.2.0")),
        .package(url: "https://github.com/vapor/auth.git", from: "2.0.0-rc")
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor", "Leaf", "FluentMySQL", "Markdown", "SwiftSlug", "Authentication"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)
