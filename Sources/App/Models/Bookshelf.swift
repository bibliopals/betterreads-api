//
//  Bookshelf.swift
//  App
//
//  Created by Russell Blickhan on 12/8/19.
//

import FluentPostgreSQL
import Vapor

struct Bookshelf: PostgreSQLModel {
    var id: Int?

    var userID: User.ID

    var name: String

    // Whether this bookshelf is private to this user
    var `private`: Bool
}

extension Bookshelf {
    // User that owns the bookshelf
    var user: Parent<Bookshelf, User> { parent(\.userID) }
}

extension Bookshelf {
    // Books contained in bookshelf
    var books: Siblings<Bookshelf, Book, BookBookshelf> { siblings() }
}

extension Bookshelf {
    func isVisible(for req: Request) throws -> Bool {
        try !`private` || req.requireAuthenticated(User.self).id == userID
    }
}

extension Bookshelf: Migration {}

extension Bookshelf: Content {}
