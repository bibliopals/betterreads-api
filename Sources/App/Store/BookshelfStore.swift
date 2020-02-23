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
        let books: Siblings<Bookshelf, Book, BookBookshelf> = bookshelf.siblings()
        return try books.query(on: req).all()
    }
}
