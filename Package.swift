// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "betterreads-api",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.3.1"),

        // Swift ORM for Postgres
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "1.0.0"),

        // 👤 Authentication and Authorization layer for Fluent.
        .package(url: "https://github.com/vapor/auth.git", from: "2.0.4"),

        // GraphQL
        .package(url: "https://github.com/alexsteinerde/Graphiti.git", from: "0.12.0"),
    ],
    targets: [
        .target(name: "App", dependencies: ["Authentication", "FluentPostgreSQL", "Graphiti", "Vapor"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"]),
    ]
)
