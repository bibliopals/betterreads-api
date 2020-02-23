//
//  Book.swift
//  App
//
//  Created by Russell Blickhan on 12/6/19.
//

import FluentPostgreSQL
import Graphiti
import Vapor

typealias ISBN = String

struct Book: PostgreSQLModel, Codable {
    var id: Int?

    var isbn: String
    var title: String
    var description: ISBN
}

extension Book: Migration {}

extension Book: FieldKeyProvider {
    typealias FieldKey = FieldKeys

    enum FieldKeys: String {
        case isbn
        case title
        case description
    }
}
