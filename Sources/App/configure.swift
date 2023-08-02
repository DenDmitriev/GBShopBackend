import NIOSSL
import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    if let workingDirectory = URL(string: app.directory.workingDirectory) {
        let dataDirectory = workingDirectory.appendingPathComponent("data")
        if !FileManager.default.fileExists(atPath: dataDirectory.path) {
            do {
                try FileManager.default.createDirectory(atPath: dataDirectory.path, withIntermediateDirectories: true)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    let databasePath = app.directory.workingDirectory + "data/db.sqlite"
    
//    let databasePath = "/data/db.sqlite"
    print("database exists on path", databasePath, FileManager.default.fileExists(atPath: databasePath))
    app.databases.use(.sqlite(.file(databasePath)), as: .sqlite)

    app.migrations.add(CreateTodo())
    app.migrations.add(CreateUser())
    app.migrations.add(UserToken.Migration())
    app.migrations.add(CreateProduct())
    app.migrations.add(CreateReviews())
    app.migrations.add(CreateCategory())
//    app.migrations.add(CreateBasket())
    
    let basketMigration = CreateBasket()
    try await basketMigration.revert(on: app.db)
    try await basketMigration.prepare(on: app.db)
    
    try await app.autoMigrate()

    // register routes
    try routes(app)
}
