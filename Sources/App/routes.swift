import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    try app.register(collection: TodoController())
    try app.register(collection: AuthController())
    try app.register(collection: UserController())
    try app.register(collection: ProductController())
    try app.register(collection: CategoryController())
    try app.register(collection: ReviewController())
    try app.register(collection: BasketController())
}
