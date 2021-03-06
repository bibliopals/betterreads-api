//
//  BetterreadsAPI.swift
//  App
//
//  Created by Russell Blickhan on 2/21/20.
//

import Graphiti
import Vapor

/// Top-level GraphQL API keys and resolvers.
struct BetterreadsAPI: FieldKeyProvider {
    typealias FieldKey = FieldKeys

    enum FieldKeys: String {
        // Arguments
        case isbn
        case name
        case email
        case password
        case verifyPassword
        case userID
        case title
        case `private`
        case bookshelfID

        // Queries
        case book
        case user
        case bookshelf

        // Mutations
        case createUser
        case createBookshelf
        case addBook
        case removeBook
    }

    // MARK: Queries

    struct BookArguments: Codable {
        let isbn: ISBN
    }

    func book(req: Request, args: BookArguments) throws -> Future<Book> {
        try BookStore.book(isbn: args.isbn, req: req)
    }

    struct UserArguments: Codable {
        let userID: Int
    }

    func user(req: Request, args: UserArguments) throws -> Future<User> {
        try UserStore.user(id: args.userID, req: req)
    }

    struct BookshelfArguments: Codable {
        let bookshelfID: Int
    }

    func bookshelf(req: Request, args: BookshelfArguments) throws -> Future<Bookshelf> {
        try BookshelfStore.bookshelf(id: args.bookshelfID, req: req)
    }

    // MARK: Mutations

    struct CreateUserArguments: Codable {
        let name: String
        let email: String
        let password: String
        /// Repeated password to verify it was typed correctly
        let verifyPassword: String
    }

    func createUser(req: Request, args: CreateUserArguments) throws -> Future<User> {
        try UserStore.create(
            name: args.name,
            email: args.email,
            password: args.password,
            verifyPassword: args.verifyPassword,
            req: req
        )
    }

    struct CreateBookshelfArguments: Codable {
        let title: String
        let `private`: Bool
    }

    func createBookshelf(req: Request, args: CreateBookshelfArguments) throws -> Future<Bookshelf> {
        try BookshelfStore.create(title: args.title, private: args.private, req: req)
    }

    struct AddBookArguments: Codable {
        let isbn: String
        let bookshelfID: Int
    }

    func addBook(req: Request, args: AddBookArguments) throws -> Future<[Book]> {
        try BookStore.book(isbn: args.isbn, req: req)
            .and(BookshelfStore.bookshelf(id: args.bookshelfID, req: req))
            .flatMap { try BookshelfStore.add($0.0, to: $0.1, req: req) }
    }

    struct DeleteBookArguments: Codable {
        let isbn: String
        let bookshelfID: Int
    }

    func removeBook(req: Request, args: DeleteBookArguments) throws -> Future<[Book]> {
        try BookStore.book(isbn: args.isbn, req: req)
            .and(BookshelfStore.bookshelf(id: args.bookshelfID, req: req))
            .flatMap { try BookshelfStore.remove($0.0, from: $0.1, req: req) }
    }
}
