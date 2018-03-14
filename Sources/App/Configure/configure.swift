import Vapor
import Fluent
import FluentMySQL
import Leaf

/// Called before your application initializes.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#configureswift)
public func configure(
  _ config: inout Config,
  _ env: inout Environment,
  _ services: inout Services
  ) throws {

  // Register routes to the router
  let router = EngineRouter.default()
  try routes(router)
  services.register(router, as: Router.self)
  
  // Register middleware
  configureRouteLogginMiddleware(&services, env: env)
  
  // Leaf
  try services.register(LeafProvider())
  config.prefer(LeafRenderer.self, for: TemplateRenderer.self)
  configureLeafTags(&services)

  // Database
  try configureDatabase(&services, env)

}

private func configureRouteLogginMiddleware(_ services: inout Services, env: Environment) {
  
  var middlewares = MiddlewareConfig.default()
  
  if !env.isRelease {
    services.register(RouteLoggingMiddleware.self)
    middlewares.use(RouteLoggingMiddleware.self)
  }
  
  services.register(middlewares)
}

private func configureLeafTags(_ services: inout Services) {
  var tags = LeafTagConfig.default()
  tags.use(MarkdownTag(), as: "markdown")
  tags.use(LinkTag(), as: "link")
  services.register(tags)
}

private func configureDatabase(_ services: inout Services, _ env: Environment) throws {
  try services.register(FluentMySQLProvider())
  var databaseConfig = DatabaseConfig()
  let db = MySQLDatabase(
    hostname: "localhost",
    user: "cocoaheadsweb",
    password: "test",
    database: "test")
  databaseConfig.add(database: db, as: .mysql)
  services.register(databaseConfig)
  
  let migrationConfig = MigrationConfig()
  //migrationConfig.add(model: Category.self, database: .mysql)
  //migrationConfig.add(model: Post.self, database: .mysql)
  services.register(migrationConfig)
}
