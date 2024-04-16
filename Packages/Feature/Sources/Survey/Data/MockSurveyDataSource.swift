import Foundation
import Models

#if DEBUG

final class MockSurveyDataSource: SurveyDataSource {
    func start() async -> Result<Survey, Error> {
        .success(Survey.example)
    }
    
    func submit(answer: Answer) async -> Result<EmptyResponse, Error> {
        .success(EmptyResponse())
    }
}

#endif
