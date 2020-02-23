import Authentication
import FluentPostgreSQL
import GraphiQLVapor
import GraphQLKit
import Vapor

/// Called before your application initializes.
public func configure(_: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentPostgreSQLProvider())
    try services.register(AuthenticationProvider())

    // Register routes to the router
    let router = EngineRouter.default()

    let basic = router.grouped(User.basicAuthMiddleware(using: BCryptDigest()))
    basic.post("login") { (req) -> Future<UserToken> in
        let user = try req.requireAuthenticated(User.self)
        return try UserToken.create(userID: user.requireID()).save(on: req)
    }

    let bearer = router.grouped(User.tokenAuthMiddleware())
    bearer.register(graphQLSchema: schema, withResolver: BetterreadsAPI())

    if !env.isRelease {
        router.enableGraphiQL()
    }

    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(SessionsMiddleware.self) // Enables sessions.
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure the connection to the psql database
    let psql = try PostgreSQLDatabase(config: {
        if env == .development {
            return try PostgreSQLDatabaseConfig.default()
        } else if env == .production {
            // TODO:
            return try PostgreSQLDatabaseConfig.default()
        } else if env == .testing {
            // TODO:
            return try PostgreSQLDatabaseConfig.default()
        } else if env == .custom(name: "docker") {
            return PostgreSQLDatabaseConfig(hostname: "db", username: "postgres")
        } else {
            assert(false, "Unknown environment")
            return try PostgreSQLDatabaseConfig.default()
        }
    }())

    // Register the configured psql database to the database config
    var databases = DatabasesConfig()
    databases.enableLogging(on: .psql)
    databases.add(database: psql, as: .psql)
    services.register(databases)

    // Migrations
    services.register { _ -> MigrationConfig in
        var migrationConfig = MigrationConfig()
        try migrate(migrations: &migrationConfig)
        return migrationConfig
    }
}
