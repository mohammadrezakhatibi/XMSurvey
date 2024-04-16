import XCTest
import Survey
import Models

final class QuestionViewModelTests: XCTestCase {
    
    func test_viewModel_doseNotRequestOnInstantiation(){
        let (_, client) = makeSUT()
        XCTAssertEqual(client.urls, [])
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
    
}
