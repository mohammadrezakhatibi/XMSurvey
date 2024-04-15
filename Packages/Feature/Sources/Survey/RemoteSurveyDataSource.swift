import Foundation
import Models
import HTTPClient

public final class RemoteSurveyDataSource: SurveyDataSource {
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    
    public func start() async -> Result<Survey, Error> {
        _ = await client.get(url: SurveyEndPoints.list.url)
        return .success(.example)
    }
}
