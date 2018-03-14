import Async
import Debugging
import HTTP
import Service
import Vapor

final class RouteLoggingMiddleware: Middleware, Service {

  init() {}

  func respond(to request: Request, chainingTo next: Responder) throws -> Future<Response> {

    let method = request.http.method
    let path = request.http.uri.path

    var queryString = ""
    if let query = request.http.uri.query, !query.isEmpty {
      queryString = " with query:\(query)"
    }
    let reqString = "👉 REQUEST \(method): \(path)" +  queryString
    print(reqString)
    print("👉 HEADER:\n====\n\(request.http.headers.debugDescription)====")
    print("👉 BODY:\n====\n\(request.http.body.debugDescription)\n====")
    return try next.respond(to: request).do { response in
      let code = String(response.http.status.code)
      let message = response.http.status.message
      let resString = "\n👈 RESPONSE \(message), code: \(code)"
      print(resString)
      print("👈 HEADER:\n====\n\(response.http.headers.debugDescription)====")
      print("👈 BODY:\n====\n\(response.http.body.debugDescription)\n====")
    }
  }
}

extension RouteLoggingMiddleware: ServiceType {
  static func makeService(for worker: Container) throws -> Self {
    return .init()
  }
}
