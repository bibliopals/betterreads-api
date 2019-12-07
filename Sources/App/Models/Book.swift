//
//  Book.swift
//  App
//
//  Created by Russell Blickhan on 12/6/19.
//

import Vapor
import FluentPostgreSQL

typealias ISBN = String

final class Book: PostgreSQLModel {
    var id: Int?
    
    var isbn: String
    
    var description: ISBN
}

extension Book: Migration { }

extension Book: Content { }