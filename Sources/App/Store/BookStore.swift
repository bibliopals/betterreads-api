//
//  BookStore.swift
//  App
//
//  Created by Russell Blickhan on 2/22/20.
//

import FluentPostgreSQL
import Vapor

final class BookStore {
    static func book(isbn: ISBN, req: Request) throws -> Future<Book> {
        Book.query(on: req)
            .filter(\.isbn == isbn).first()
            .unwrap(or: Abort(.notFound))
    }
}
