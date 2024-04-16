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
    
    func test_ready_whenStartSurveySucceed() async {
        let (sut, _) = makeSUT(result: .success(EmptyResponse()))
        let expectedAnswer = "Answer"
        
        sut.answer = expectedAnswer
        await sut.submitAnswer()
        
        XCTAssertEqual(sut.submitDisabled, true)
        XCTAssertEqual(sut.question.answer, expectedAnswer)
        XCTAssertEqual(sut.question.hasAnswer, true)
        
        expect(
            sut,
            toCompleteWith: .success(EmptyResponse())
        )
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
    
    private func expect(
        _ sut: QuestionViewModel,
        toCompleteWith expectedResult: Result<EmptyResponse, Error>,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        
        if case .success(_) = expectedResult {
            XCTAssertEqual(
                sut.viewState,
                .success
            )
        } else if case .failure(_) = expectedResult {
            XCTAssertEqual(sut.viewState, .failure)
        } else {
            XCTFail(file: file, line: line)
        }
    }
    
}
