import NIOSSL
import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    let databasePath = app.directory.workingDirectory + "data/db.sqlite"
    print("database exists on path", databasePath, FileManager.default.fileExists(atPath: databasePath))
    app.databases.use(.sqlite(.file(databasePath)), as: .sqlite)

    app.migrations.add(CreateTodo())

    // register routes
    try routes(app)
}
