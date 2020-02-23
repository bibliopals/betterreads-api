//
//  Bookshelf.swift
//  App
//
//  Created by Russell Blickhan on 12/8/19.
//

import FluentPostgreSQL

struct Bookshelf: PostgreSQLModel, Codable {
    var id: Int?
    var userID: User.ID
    var title: String
    /// Whether this bookshelf is private to this user
    var `private`: Bool
}

extension Bookshelf: Migration {}
