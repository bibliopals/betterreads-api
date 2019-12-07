//
//  BookController.swift
//  App
//
//  Created by Russell Blickhan on 12/6/19.
//

import Vapor
import FluentPostgreSQL

/// Books controller
final class BookController {
    /// Return a list of all books
    func index(_ req: Request) throws -> Future<[Book]> {
        // TODO this should be paginated :)
        return Book.query(on: req).all()
    }
    
    /// Return details for an individual book, requested by ISBN
    func details(_ req: Request) throws -> Future<Book> {
        let isbn = try req.parameters.next(ISBN.self)
        
        return Book.query(on: req).filter(\.isbn == isbn).first().map { book -> Book in
            guard let book = book else { throw Abort(.notFound) }
            return book
        }
    }
}
