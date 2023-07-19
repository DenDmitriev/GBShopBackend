import NIOSSL
import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

//    let databasePath = app.directory.workingDirectory + "data/db.sqlite"
    let databasePath = "/data/db.sqlite"
    print("database exists on path", databasePath, FileManager.default.fileExists(atPath: databasePath))
    app.databases.use(.sqlite(.file(databasePath)), as: .sqlite)

    app.migrations.add(CreateTodo())
    app.migrations.add(CreateUser())
    app.migrations.add(UserToken.Migration())
    app.migrations.add(CreateProduct())
    app.migrations.add(CreateReviews())
    app.migrations.add(CreateCategory())
    app.migrations.add(CreateBasket())
    
    try await app.autoRevert()
//    try await app.autoMigrate()

    // register routes
    try routes(app)
}
