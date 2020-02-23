//
//  schema.swift
//  App
//
//  Created by Russell Blickhan on 2/21/20.
//

import Graphiti
import Vapor

let schema = Schema<BetterreadsAPI, Request>([
    Type(Book.self, fields: [
        Field(.isbn, at: \.isbn),
        Field(.title, at: \.title),
        Field(.description, at: \.description),
    ])
        .description("An individual book."),

    Type(Bookshelf.self, fields: [
        Field(.books, at: Bookshelf.books),
        Field(.id, at: \.id),
        Field(.name, at: \.name),
        Field(.private, at: \.private)
    ])
        .description("A user's bookshelf."),
    
    Type(User.self, fields: [
        Field(.bookshelves, at: User.bookshelves),
        Field(.email, at: \.email),
        Field(.id, at: \.id),
        Field(.name, at: \.name),
    ])
        .description("A user."),

    Query([
        Field(.book, with: BetterreadsAPI.book)
            .argument(.isbn, at: \.isbn)
            .description("Retrieve data for a single book."),
    ]),
])
