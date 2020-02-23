//
//  BookshelfStore.swift
//  App
//
//  Created by Russell Blickhan on 2/22/20.
//

import FluentPostgreSQL
import Vapor

final class BookshelfStore {
    static func books(on bookshelf: Bookshelf, req: Request) throws -> Future<[Book]> {
        guard try bookshelf.isVisible(for: req) else { throw Abort(.unauthorized) }
        let books: Siblings<Bookshelf, Book, BookBookshelf> = bookshelf.siblings()
        return try books.query(on: req).all()
    }

    static func create(title: String, private: Bool, req: Request) throws -> Future<Bookshelf> {
        let user = try req.requireAuthenticated(User.self)
        return try Bookshelf(userID: user.requireID(), title: title, private: `private`).save(on: req)
    }

    static func bookshelf(id: Int, req: Request) throws -> Future<Bookshelf> {
        Bookshelf.query(on: req)
            .filter(\.id == id).first()
            .unwrap(or: Abort(.notFound))
            .map { bookshelf in
                guard try bookshelf.isVisible(for: req) else { throw Abort(.unauthorized) }
                return bookshelf
            }
    }
}

extension Bookshelf {
    func isVisible(for req: Request) throws -> Bool {
        try !`private` || req.requireAuthenticated(User.self).id == userID
    }
}
