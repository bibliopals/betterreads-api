//
//  Book+Resolvers.swift
//  App
//
//  Created by Russell Blickhan on 2/22/20.
//

import Graphiti

// MARK: Field Keys

extension Book: FieldKeyProvider {
    typealias FieldKey = FieldKeys

    enum FieldKeys: String {
        case isbn
        case title
        case description
    }
}
