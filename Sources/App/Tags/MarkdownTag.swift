import Async
import Foundation
import Leaf
import Markdown

public final class MarkdownTag: TagRenderer {
  public func render(tag parsed: TagContext) throws -> Future<TemplateData> {
    try parsed.requireParameterCount(1)
    let promise = Promise(TemplateData.self)

    if let str = parsed.parameters[0].string {
      let trimmed = str.replacingOccurrences(of: "\r\n", with: "\n")
      let md = try Markdown(string: trimmed)
      let doc = try md.document()
      promise.complete(.string(doc))
    } else {
      promise.complete(.null)
    }

    return promise.future
  }

}
