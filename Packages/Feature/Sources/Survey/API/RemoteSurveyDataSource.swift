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
            do {
                guard let survey = try? SurveyDataMapper.map(data, from: response) else {
                    return .failure(Error.decoding)
                }
                return .success(survey)
            }
        }
        return .failure(Error.server)
    }
    
    public func submit(answer: Answer) async -> Result<EmptyResponse, Swift.Error> {
        let result = await client.post(url: SurveyEndPoints.submit.url, body: answer)
        if case .success(let (_, response)) = result {
            if response?.statusCode == 200 {
                return .success(EmptyResponse())
            } else {
                return .failure(Error.server)
            }
        }
        return .failure(Error.server)
    }
}
