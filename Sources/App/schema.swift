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
        Field(.books, with: Bookshelf.books),
        Field(.id, at: \.id),
        Field(.title, at: \.title),
        Field(.private, at: \.private),
    ])
        .description("A user's bookshelf."),

    Type(User.self, fields: [
        Field(.bookshelves, with: User.bookshelves),
        Field(.email, at: \.email),
        Field(.id, at: \.id),
        Field(.name, at: \.name),
    ])
        .description("A user."),

    Query([
        Field(.book, with: BetterreadsAPI.book)
            .argument(.isbn, at: \.isbn)
            .description("Retrieve data for a single book."),
        Field(.user, with: BetterreadsAPI.user)
            .argument(.userID, at: \.userID)
            .description("Retrieve data for a single user."),
        Field(.bookshelf, with: BetterreadsAPI.bookshelf)
            .argument(.bookshelfID, at: \.bookshelfID)
            .description("Retrieve data for a single bookshelf, if visible."),
    ]),

    Mutation([
        Field(.createUser, with: BetterreadsAPI.createUser)
            .argument(.name, at: \.name)
            .argument(.email, at: \.email)
            .argument(.password, at: \.password)
            .argument(.verifyPassword, at: \.verifyPassword)
            .description("Create a new user account."),
        Field(.createBookshelf, with: BetterreadsAPI.createBookshelf)
            .argument(.title, at: \.title)
            .argument(.private, at: \.private)
            .description("Create a new bookshelf for the currently logged-in user."),
    ]),
])
