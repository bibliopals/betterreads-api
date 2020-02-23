//
//  UserStore.swift
//  App
//
//  Created by Russell Blickhan on 2/22/20.
//

import FluentPostgreSQL
import Vapor

final class UserStore {
    static func user(id: Int, req: Request) throws -> Future<User> {
        User.query(on: req)
            .filter(\.id == id).first()
            .unwrap(or: Abort(.notFound))
    }

    static func bookshelves(userID: Int?, req: Request) throws -> Future<[Bookshelf]> {
        guard let userID = userID else { throw Abort(.notFound) }
        return Bookshelf.query(on: req)
            .filter(\.userID == userID).all()
            .map { bookshelves in
                try bookshelves.filter { try $0.isVisible(for: req) }
            }
    }
}
