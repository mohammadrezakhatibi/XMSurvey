import Foundation
import Models
import HTTPClient

public final class RemoteSurveyDataSource: SurveyDataSource {
    public enum Error: Swift.Error {
        case server
    }
    
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    
    public func start() async -> Result<Survey, Swift.Error> {
        _ = await client.get(url: SurveyEndPoints.list.url)
        return .failure(Error.server)
    }
}
