//
//  User+Resolvers.swift
//  App
//
//  Created by Russell Blickhan on 2/22/20.
//

import Graphiti
import Vapor

// MARK: Field Keys

extension User: FieldKeyProvider {
    typealias FieldKey = FieldKeys

    enum FieldKeys: String {
        case bookshelves
        case email
        case id
        case name
    }
}

// MARK: Resolvers

extension User {
    func bookshelves(req: Request, _: NoArguments) throws -> Future<[Bookshelf]> {
        try UserStore.bookshelves(userID: id, req: req)
    }
}
