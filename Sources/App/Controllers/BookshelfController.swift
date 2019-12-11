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
    func bookshelf(_ req: Request) throws -> Future<Bookshelf> {
        let bookshelfID = try req.parameters.next(Bookshelf.ID.self)

        return Bookshelf.query(on: req)
            .filter(\.id == bookshelfID).first().map { bookshelf in
                guard let bookshelf = bookshelf else { throw Abort(.notFound) }

                guard try bookshelf.isVisible(for: req) else { throw Abort(.unauthorized) }

                return bookshelf
            }
    }

    /// Return book list for a given bookshelf
    func books(_ req: Request) throws -> Future<[Book]> {
        let bookshelfID = try req.parameters.next(Bookshelf.ID.self)

        return Bookshelf.query(on: req)
            .filter(\.id == bookshelfID).first().flatMap { bookshelf in
                guard let bookshelf = bookshelf else { throw Abort(.notFound) }

                guard try bookshelf.isVisible(for: req) else { throw Abort(.unauthorized) }

                return try bookshelf.books.query(on: req).all()
            }
    }

    // TODO: endpoint to add a book to a bookshelf
}
