//
//  BetterreadsAPI.swift
//  App
//
//  Created by Russell Blickhan on 2/21/20.
//

import Graphiti
import Vapor

struct BetterreadsAPI: FieldKeyProvider {
    typealias FieldKey = FieldKeys

    enum FieldKeys: String {
        // Arguments
        case isbn

        // Queries
        case book
    }

    struct BookArguments: Codable {
        let isbn: ISBN
    }

    func book(req: Request, args: BookArguments) throws -> Future<Book> {
        try BookStore.book(isbn: args.isbn, req: req)
    }
}
