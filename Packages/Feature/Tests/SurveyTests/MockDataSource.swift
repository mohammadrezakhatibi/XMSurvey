import Foundation
import Survey
import Models

final class MockSurveyDataSource: SurveyDataSource {
    var urls: [URL] = []
    var answerRequests: [Answer] = []
    var submitResult: Result<EmptyResponse, Error>
    var result: Result<Survey, Error>
    
    init(result: Result<Survey, Error> = .success(.example),
         submitResult: Result<EmptyResponse, Error> = .success(EmptyResponse())) {
        self.result = result
        self.submitResult = submitResult
    }
    
    func start() async -> Result<Survey, Error> {
        urls.append(SurveyEndPoints.list.url)
        return result
    }
    
    func submit(answer: Answer) async -> Result<EmptyResponse, Error> {
        urls.append(SurveyEndPoints.submit.url)
        answerRequests.append(answer)
        return submitResult
    }
}
