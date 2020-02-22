//
//  BookshelfController.swift
//  App
//
//  Created by Russell Blickhan on 12/8/19.
//

import FluentPostgreSQL
import Vapor

/// Bookshelf controller
final class BookshelfController {
    /// Return details for a single bookshelf
    func bookshelf(_ req: Request) throws -> Future<Bookshelf> {
        let bookshelfID = try req.parameters.next(Bookshelf.ID.self)

        return Bookshelf.query(on: req)
            .filter(\.id == bookshelfID).first()
            .unwrap(or: Abort(.notFound))
            .map { bookshelf in
                guard try bookshelf.isVisible(for: req) else { throw Abort(.unauthorized) }

                return bookshelf
            }
    }

    /// Return book list for a bookshelf
    func books(_ req: Request) throws -> Future<[Book]> {
        let bookshelfID = try req.parameters.next(Bookshelf.ID.self)

        return Bookshelf.query(on: req)
            .filter(\.id == bookshelfID).first()
            .unwrap(or: Abort(.notFound))
            .flatMap { bookshelf in
                guard try bookshelf.isVisible(for: req) else { throw Abort(.unauthorized) }

                return try bookshelf.books.query(on: req).all()
            }
    }

    /// Create a bookshelf
    func create(_ req: Request) throws -> Future<Bookshelf> {
        let user = try req.requireAuthenticated(User.self)

        return try req.content.decode(CreateBookshelfRequest.self).flatMap { bookshelf in
            try Bookshelf(userID: user.requireID(), name: bookshelf.title, private: bookshelf.private)
                .save(on: req)
        }
    }

    /// Add a book to a bookshelf
    func add(_ req: Request) throws -> Future<[Book]> {
        let bookshelfID = try req.parameters.next(Bookshelf.ID.self)
        let user = try req.requireAuthenticated(User.self)

        return Bookshelf.query(on: req).filter(\.id == bookshelfID).first()
            .unwrap(or: Abort(.notFound))
            .flatMap { bookshelf in
                guard bookshelf.userID == user.id else { throw Abort(.unauthorized) }

                return try bookshelf.books.query(on: req).all()
            }
    }
}

struct CreateBookshelfRequest: Content {
    var title: String
    var `private`: Bool
}

struct AddBooksRequest: Content {
    var books: [ISBN]
}
