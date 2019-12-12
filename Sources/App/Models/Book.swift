//
//  Book.swift
//  App
//
//  Created by Russell Blickhan on 12/6/19.
//

import FluentPostgreSQL
import Vapor

typealias ISBN = String

struct Book: PostgreSQLModel {
    var id: Int?

    var isbn: String

    var title: String

    var description: ISBN
}

extension Book: Migration {}

extension Book: Content {}
