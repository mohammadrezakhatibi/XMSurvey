import XCTest
import Survey
import Models

final class QuestionViewModelTests: XCTestCase {
    
    func test_viewModel_doseNotRequestOnInstantiation(){
        let (_, client) = makeSUT()
        XCTAssertEqual(client.urls, [])
    }
    
    func test_submitAnswer_sendsRequestForSubmit() async {
        let (sut, repository) = makeSUT()
        await sut.submitAnswer()
        await sut.submitAnswer()
        
        XCTAssertEqual(repository.urls, [endPoint, endPoint])
    }
    
    func test_idleState_onInstantiation() async {
        let (sut, _) = makeSUT()
        
        XCTAssertEqual(sut.viewState, .idle)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        result: Result<EmptyResponse, Error> = .success(EmptyResponse()),
        question: Question = .example(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: QuestionViewModel, dataSource: MockSurveyDataSource) {
        let dataSource = MockSurveyDataSource(submitResult: result)
        let sut = QuestionViewModel(dataSource: dataSource, question: question)
        
        trackForMemoryLeaks(dataSource, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, dataSource)
    }
    
    private var endPoint: URL {
        return SurveyEndPoints.submit.url
    }
    
}
