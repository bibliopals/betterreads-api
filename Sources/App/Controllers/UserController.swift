import Crypto
import FluentPostgreSQL
import Vapor

/// Creates new users and logs them in.
final class UserController {
    /// Log in as a user
    func login(_ req: Request) throws -> Future<UserToken> {
        let user = try req.requireAuthenticated(User.self)
        return try UserToken.create(userID: user.requireID()).save(on: req)
    }

    /// Create a new user
    func create(_ req: Request) throws -> Future<UserResponse> {
        // TODO: return informative error if user exists
        try req.content.decode(CreateUserRequest.self).flatMap { user -> Future<User> in
            guard user.password == user.verifyPassword else {
                throw Abort(.badRequest, reason: "Password and verification must match.")
            }

            let hash = try BCrypt.hash(user.password)

            return User(id: nil, name: user.name, email: user.email, passwordHash: hash)
                .save(on: req)
        }.map { user in
            try UserResponse(id: user.requireID(), name: user.name, email: user.email)
        }
    }

    /// List bookshelves for a user
    func bookshelves(_ req: Request) throws -> Future<[Bookshelf]> {
        let userID = try req.parameters.next(User.ID.self)

        return Bookshelf.query(on: req).filter(\.userID == userID).all().map { bookshelves in
            try bookshelves.filter { try $0.isVisible(for: req) }
        }
    }
}

// MARK: Content

struct CreateUserRequest: Content {
    var name: String

    var email: String

    var password: String

    /// Repeated password to verify it was typed correctly
    var verifyPassword: String
}

struct UserResponse: Content {
    var id: Int

    var name: String

    var email: String
}
