import NIOSSL
import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // Configure custom hostname.
    // app.http.server.configuration.hostname = "hostname"
    // Configure custom port.
    app.http.server.configuration.port = 80
    
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

    app.migrations.add(CreateTodo())

    // register routes
    try routes(app)
}
