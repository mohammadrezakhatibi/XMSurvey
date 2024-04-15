import Foundation

public func successHTTPResponse() -> HTTPURLResponse {
    return anyHTTPURLResponse(statusCode: 200)
}

public func anyHTTPURLResponse(statusCode: Int = 200) -> HTTPURLResponse {
    return HTTPURLResponse(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: [:])!
}

public func anyURL() -> URL {
    URL(string: "http://any-url.com")!
}

public func anyData() -> Data {
    Data("anyData".utf8)
}

public func anyError() -> Error {
    NSError(domain: "", code: 1)
}

public extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
