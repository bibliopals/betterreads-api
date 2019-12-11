import Crypto
import FluentPostgreSQL
import Vapor

/// Creates new users and logs them in.
final class UserController {
    /// Logs a user in, returning a token for accessing protected endpoints.
    func login(_ req: Request) throws -> Future<UserToken> {
        let user = try req.requireAuthenticated(User.self)
        return try UserToken.create(userID: user.requireID()).save(on: req)
    }

    /// Creates a new user.
    func create(_ req: Request) throws -> Future<UserResponse> {
        // TODO return informative error if user exists
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

    /// List all bookshelves for given user
    func bookshelves(_ req: Request) throws -> Future<[Bookshelf]> {
        let userID = try req.parameters.next(User.ID.self)

        return Bookshelf.query(on: req).filter(\.userID == userID).all().map { bookshelves in
            try bookshelves.filter { try $0.isVisible(for: req) }
        }
    }
}

// MARK: Content

/// Data required to create a user.
struct CreateUserRequest: Content {
    /// User's full name.
    var name: String

    /// User's email address.
    var email: String

    /// User's desired password.
    var password: String

    /// User's password repeated to ensure they typed it correctly.
    var verifyPassword: String
}

/// Public representation of user data.
struct UserResponse: Content {
    /// User's unique identifier.
    /// Not optional since we only return users that exist in the DB.
    var id: Int

    /// User's full name.
    var name: String

    /// User's email address.
    var email: String
}
