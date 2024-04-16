import Foundation
import Models
import HTTPClient

public protocol SurveyDataSource {
    func start() async -> Result<Survey, Error>
    func submit(answer: Answer) async -> Result<EmptyResponse, Error>
}
