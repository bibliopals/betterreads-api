//
//  BookBookshelf.swift
//  App
//
//  Created by Russell Blickhan on 12/8/19.
//

import FluentPostgreSQL

struct BookBookshelf: PostgreSQLPivot {
    typealias Left = Book
    typealias Right = Bookshelf

    static var leftIDKey: LeftIDKey = \.bookID
    static var rightIDKey: RightIDKey = \.bookshelfID

    var id: Int?
    var bookID: Book.ID
    var bookshelfID: Bookshelf.ID
}

extension BookBookshelf: Migration {}
