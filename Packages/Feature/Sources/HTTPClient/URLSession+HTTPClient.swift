import Foundation

extension URLSession: HTTPClient {
    private struct UnexpectedResponseValue: Error {}
    
    public func get(url: URL) async -> HTTPClient.Result {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse else {
                return .failure(UnexpectedResponseValue())
            }
            return .success((data, response))
            
        } catch {
            return .failure(error)
        }
    }
    
    public func post<T: Encodable>(url: URL, body: T) async -> HTTPClient.Result {
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let encoder = JSONEncoder()
            let body = try encoder.encode(body)
            request.httpBody = body
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                return .failure(UnexpectedResponseValue())
            }
            return .success((data, response))
            
        } catch {
            return .failure(error)
        }
    }
    
}
