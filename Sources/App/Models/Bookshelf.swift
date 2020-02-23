//
//  Bookshelf.swift
//  App
//
//  Created by Russell Blickhan on 12/8/19.
//

import FluentPostgreSQL
import Graphiti
import Vapor

struct Bookshelf: PostgreSQLModel, Codable {
    var id: Int?
    var userID: User.ID
    var name: String
    /// Whether this bookshelf is private to this user
    var `private`: Bool
}

extension Bookshelf {
    /// User that owns the bookshelf
    var user: Parent<Bookshelf, User> { parent(\.userID) }
}

extension Bookshelf {
    func isVisible(for req: Request) throws -> Bool {
        try !`private` || req.requireAuthenticated(User.self).id == userID
    }
}

extension Bookshelf: Migration {}

// MARK: Field Keys

extension Bookshelf: FieldKeyProvider {
    typealias FieldKey = FieldKeys
    
    enum FieldKeys: String {
        case books
        case id
        case name
        case `private`
    }
}

// MARK: Resolvers

extension Bookshelf {
    func books(req: Request, _: NoArguments) throws -> [Book] {
        try BookshelfStore.books(on: self, req: req).wait()
    }
}
