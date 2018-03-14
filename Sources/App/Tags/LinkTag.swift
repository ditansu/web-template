import Async
import Foundation
import Leaf

public final class LinkTag: TagRenderer {
  public func render(tag parsed: TagContext) throws -> Future<TemplateData> {

    try parsed.requireParameterCount(1)
    let promise = Promise(TemplateData.self)

    if let dict = parsed.parameters[0].dictionary,
      let id = dict["id"]?.string,
      let slug = dict["slug"]?.string {
      promise.complete(.string("\(id)/\(slug)"))
    } else {
      promise.complete(.null)
    }

    return promise.future
  }

}
