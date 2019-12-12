//
//  migrate.swift
//  App
//
//  Created by Russell Blickhan on 12/11/19.
//

import FluentPostgreSQL
import Vapor

public func migrate(migrations: inout MigrationConfig) throws {
    migrations.add(model: Book.self, database: .psql)
    migrations.add(model: Bookshelf.self, database: .psql)
    migrations.add(model: BookBookshelf.self, database: .psql)
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: UserToken.self, database: .psql)
}
