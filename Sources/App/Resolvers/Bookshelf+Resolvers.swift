//
//  Bookshelf+Resolvers.swift
//  App
//
//  Created by Russell Blickhan on 2/22/20.
//

import Graphiti
import Vapor

// MARK: Field Keys

extension Bookshelf: FieldKeyProvider {
    typealias FieldKey = FieldKeys

    enum FieldKeys: String {
        case books
        case id
        case title
        case `private`
    }
}

// MARK: Resolvers

extension Bookshelf {
    func books(req: Request, _: NoArguments) throws -> Future<[Book]> {
        try BookshelfStore.books(on: self, req: req)
    }
}
