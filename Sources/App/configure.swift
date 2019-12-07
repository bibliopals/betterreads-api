import Authentication
import FluentPostgreSQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentPostgreSQLProvider())
    try services.register(AuthenticationProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(SessionsMiddleware.self) // Enables sessions.
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
    
    // Configure the connection to the psql database
    let psql = try PostgreSQLDatabase(config: {
        switch env {
        case .development: return try PostgreSQLDatabaseConfig.default()
        case .production:
            // TODO
            return try PostgreSQLDatabaseConfig.default()
        case .testing:
            // TODO
            return try PostgreSQLDatabaseConfig.default()
        default:
            assert(false, "Unknown environment")
            return try PostgreSQLDatabaseConfig.default()
        }
    }())

    // Register the configured psql database to the database config
    var databases = DatabasesConfig()
    databases.enableLogging(on: .psql)
    databases.add(database: psql, as: .psql)
    services.register(databases)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Book.self, database: .psql)
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: UserToken.self, database: .psql)
    migrations.add(model: Todo.self, database: .psql)
    services.register(migrations)

}
