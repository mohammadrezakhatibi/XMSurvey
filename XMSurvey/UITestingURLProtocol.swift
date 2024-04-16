import Foundation

final class UITestingURLProtocol: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    struct ResponseData {
        let response: URLResponse
        let data: Data
    }
    
    static var responseProvider: ((URLRequest) -> Result<ResponseData, Error>)?
    
    override func startLoading() {
        guard let client else { fatalError() }
        
        if let responseProvider = Self.responseProvider {
            switch responseProvider(request) {
            case .success(let responseData):
                client.urlProtocol(self, didReceive: responseData.response, cacheStoragePolicy: .notAllowed)
                client.urlProtocol(self, didLoad: responseData.data)
                client.urlProtocolDidFinishLoading(self)
            case .failure(let error):
                client.urlProtocol(self, didFailWithError: error)
                client.urlProtocolDidFinishLoading(self)
            }
        }
        else {
            let error = NSError(domain: "UITestingURLProtocol", code: -1)
            client.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
}

public final class UITestingNetworkHandler {
    public static func register() {
        URLProtocol.registerClass(UITestingURLProtocol.self)
        
        UITestingURLProtocol.responseProvider = { request in
            guard let url = request.url else { fatalError() }
            
            switch (url.host, url.path) {
            case ("xm-assignment.web.app", "/questions"):
                let response = response(for: url, failure: CommandLine.arguments.contains("failedSurvey"))
                guard let path = Bundle.main.url(forResource: "testJSON", withExtension: "json") else {
                    fatalError("file not exist")
                }
                guard let data = try? Data(contentsOf: path, options: .alwaysMapped) else {
                    fatalError("Wrong test data")
                }
                return .success(UITestingURLProtocol.ResponseData(response: response, data: data))
                
            case ("xm-assignment.web.app", "/question/submit"):
                let response = response(for: url, failure: CommandLine.arguments.contains("failedSubmit"))
                return .success(UITestingURLProtocol.ResponseData(response: response, data: Data()))

            default:
                fatalError("Unhandled path")
            }
            fatalError("Unhandled path")
        }
    }
    
    private static func response(for url: URL, failure: Bool) -> HTTPURLResponse {
        HTTPURLResponse(
            url: url,
            statusCode: failure ? 400 : 200,
            httpVersion: nil,
            headerFields: nil
        )!
    }
}
