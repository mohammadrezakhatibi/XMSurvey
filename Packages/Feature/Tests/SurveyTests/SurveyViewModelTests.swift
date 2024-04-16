import XCTest
import Models
import Survey

final class SurveyViewModelTests: XCTestCase {
    
    func test_viewModel_doseNotRequestOnInstantiation(){
        let (_, client) = makeSUT()
        XCTAssertEqual(client.urls, [])
    }
    
    func test_start_getsSurvey() async {
        let (sut, repository) = makeSUT()
        await sut.start()
        await sut.start()
        
        XCTAssertEqual(repository.urls, [endPoint, endPoint])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        result: Result<Survey, Error> = .success(.init(questions: [])),
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: SurveyViewModel, dataSource: MockSurveyDataSource) {
        let dataSource = MockSurveyDataSource(result: result)
        let sut = SurveyViewModel(dataSource: dataSource)
        
        trackForMemoryLeaks(dataSource, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, dataSource)
    }
    
    private var endPoint: URL {
        return SurveyEndPoints.list.url
    }
}
