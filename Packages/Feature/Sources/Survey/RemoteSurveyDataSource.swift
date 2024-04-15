import Foundation
import Models
import HTTPClient

public final class RemoteSurveyDataSource: SurveyDataSource {
    public enum Error: Swift.Error {
        case server
        case decoding
    }
    
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    
    public func start() async -> Result<Survey, Swift.Error> {
        let result = await client.get(url: SurveyEndPoints.list.url)
        if case .success(let (data, response)) = result {
            return .failure(Error.decoding)
        }
        return .failure(Error.server)
    }
}
