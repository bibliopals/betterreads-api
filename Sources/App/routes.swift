import Crypto
import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // public routes
    let userController = UserController()
    router.post("users", use: userController.create)

    let bookController = BookController()
    router.get("books", use: bookController.index)
    router.get("books", ISBN.parameter, use: bookController.details)

    let bookshelfController = BookshelfController()

    // basic / password auth protected routes
    let basic = router.grouped(User.basicAuthMiddleware(using: BCryptDigest()))
    basic.post("login", use: userController.login)

    // bearer / token auth protected routes
    let bearer = router.grouped(User.tokenAuthMiddleware())
    let todoController = TodoController()
    bearer.get("todos", use: todoController.index)
    bearer.post("todos", use: todoController.create)
    bearer.delete("todos", Todo.parameter, use: todoController.delete)
    basic.get("users", User.ID.parameter, "bookshelves", use: userController.bookshelves)
    bearer.get("bookshelves", Bookshelf.ID.parameter, use: bookshelfController.bookshelf)
    bearer.get("bookshelves", Bookshelf.ID.parameter, "books", use: bookshelfController.books)
}
