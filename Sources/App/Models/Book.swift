//
//  Book.swift
//  App
//
//  Created by Russell Blickhan on 12/6/19.
//

import FluentPostgreSQL

typealias ISBN = String

struct Book: PostgreSQLModel, Codable {
    /// Not intended to be exposed.
    var id: Int?
    var isbn: ISBN
    var title: String
    var description: String
}

extension Book: Migration {}
