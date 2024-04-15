import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data?, HTTPURLResponse?), Error>
    
    func get(url: URL) async -> Result
    func post<T: Encodable>(url: URL, body: T) async -> Result
}
