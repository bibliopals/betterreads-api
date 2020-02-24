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
        return try bookshelf.shelvedBooks.query(on: req).all()
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

    static func add(_ book: Book, to bookshelf: Bookshelf, req: Request) throws -> Future<[Book]> {
        let user = try req.requireAuthenticated(User.self)
        guard bookshelf.userID == user.id else { throw Abort(.unauthorized) }

        return bookshelf.shelvedBooks.attach(book, on: req)
            .flatMap { _ in try bookshelf.shelvedBooks.query(on: req).all() }
    }

    static func remove(_ book: Book, from bookshelf: Bookshelf, req: Request) throws -> Future<[Book]> {
        let user = try req.requireAuthenticated(User.self)
        guard bookshelf.userID == user.id else { throw Abort(.unauthorized) }

        return bookshelf.shelvedBooks.detach(book, on: req)
            .flatMap { _ in try bookshelf.shelvedBooks.query(on: req).all() }
    }
}

extension Bookshelf {
    func isVisible(for req: Request) throws -> Bool {
        try !`private` || req.requireAuthenticated(User.self).id == userID
    }
}
