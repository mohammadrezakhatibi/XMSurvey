import Foundation

public protocol EndPoint: RawRepresentable<String> {
    var baseURL: URL { get }
    var url: URL { get }
}

public extension EndPoint {
    var baseURL: URL {
        #if DEBUG
        URL(string: "https://xm-assignment.web.app")!
        #else
        URL(string: "https://xm-assignment.web.app")!
        #endif
    }
    
    var url: URL {
        var components = URLComponents()
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        components.path = baseURL.path + self.rawValue
        
        guard let url = components.url else {
            fatalError("The URL is not correct")
        }
        
        return url
    }
}
