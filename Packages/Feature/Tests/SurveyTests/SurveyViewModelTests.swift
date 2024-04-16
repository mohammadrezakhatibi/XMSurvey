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
    
    func test_stateLoading_onInstantiation() async {
        let (sut, _) = makeSUT()
        
        XCTAssertEqual(sut.viewState, .loading)
    }
    
    func test_stateError_whenGetSurveyFails() async {
        let anyError = NSError(domain: "", code: 0)
        let (sut, _) = makeSUT(result: .failure(anyError))
        
        await sut.start()
        
        expect(
            sut,
            toCompleteWith: .failure(anyError)
        )
    }
    
    func test_stateReady_whenGetSurveySucceed() async {
        let expectedSurvey = Survey(questions: [Question(id: 1, question: "Test Question")])
        let (sut, _) = makeSUT(result: .success(expectedSurvey))
        
        await sut.start()
        
        expect(
            sut,
            toCompleteWith: .success(expectedSurvey)
        )
    }
    
    func test_changeQuestion_changeCurrentIndex() {
        let expectedSurvey = Survey(
            questions: [
                .example,
                .example,
            ]
        )
        let (sut, _) = makeSUT(result: .success(expectedSurvey))
        
        sut.nextQuestion()
        
        XCTAssertEqual(sut.index, 2)
        
        sut.previousQuestion()
        XCTAssertEqual(sut.index, 1)
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
    
    private func expect(
        _ sut: SurveyViewModel,
        toCompleteWith expectedResult: Result<Survey, Error>,
        when action: @escaping () -> Void = {},
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        action()
        
        if case .success(let viewData) = expectedResult {
            XCTAssertEqual(
                sut.viewState,
                .ready(
                    viewData.questions.map {
                        QuestionViewModel(dataSource: MockSurveyDataSource(), question: $0)
                    }
                )
            )
        } else if case .failure(let error) = expectedResult {
            XCTAssertEqual(sut.viewState, .error(error.localizedDescription))
        } else {
            XCTFail(file: file, line: line)
        }
    }
}

extension SurveyViewModel.ViewState: Equatable {
    public static func == (lhs: SurveyViewModel.ViewState, rhs: SurveyViewModel.ViewState) -> Bool {
        switch (lhs, rhs) {
        case (.ready, .ready):
            return true
        case (.loading, .loading):
            return true
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}
