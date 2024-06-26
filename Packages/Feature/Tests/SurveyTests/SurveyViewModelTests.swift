import XCTest
import Models
import Survey
import Combine

final class SurveyViewModelTests: XCTestCase {
    private var cancellable: AnyCancellable?
    
    override func tearDown() {
        cancellable = nil
        super.tearDown()
    }
    
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
                .example(),
                .example(id: 2),
            ]
        )
        let (sut, _) = makeSUT(result: .success(expectedSurvey))
        
        sut.nextQuestion()
        
        XCTAssertEqual(sut.index, 2)
        
        sut.previousQuestion()
        XCTAssertEqual(sut.index, 1)
    }
    
    func test_screenTitle() async {
        let expectedSurvey = Survey(
            questions: [
                .example(),
                .example(id: 2),
            ]
        )
        let (sut, _) = makeSUT(result: .success(expectedSurvey))
        
        await sut.start()
        
        XCTAssertEqual(sut.screenTitle, "Questions 1/2")
    }
    
    func test_failedSurvey_createEmptyQuestionViewModel() async {
        let anyError = NSError(domain: "", code: 0)
        
        let (sut, _) = makeSUT(result: .failure(anyError))
        
        // Get Survey's Questions
        await sut.start()
        
        XCTAssertTrue(sut.survey.isEmpty)
    }
    
    func test_start_createQuestionViewModel() async {
        let expectedSurvey = Survey(
            questions: [.example(), .example(id: 2), .example(id: 3)]
        )
        
        let (sut, _) = makeSUT(result: .success(expectedSurvey))
        
        // Get Survey's Questions
        await sut.start()
        
        expectedSurvey.questions.enumerated().forEach { index, question in
            XCTAssertEqual(question, sut.survey[index].question)
        }
    }
    
    func test_submitAnswer_changeNumberOfSubmittedTitle() async {
        let expectedSurvey = Survey(
            questions: [.example(), .example(id: 2)]
        )
        
        let (sut, _) = makeSUT(result: .success(expectedSurvey))
        
        XCTAssertEqual(sut.numberOfSubmittedTitle, "Questions Submitted: 0")
        
        // Get Survey's Questions
        await sut.start()
        
        // Submit first answer
        await submitAnswer(for: sut.survey.first)
        XCTAssertEqual(sut.numberOfSubmittedTitle, "Questions Submitted: 1")
        
        // Submit second answer
        await submitAnswer(for: sut.survey.last)
        XCTAssertEqual(sut.numberOfSubmittedTitle, "Questions Submitted: 2")
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
    
    private func submitAnswer(for viewModel: QuestionViewModel?) async {
        viewModel?.answer = "Answer"
        await viewModel?.submitAnswer()
        
        let exp = expectation(description: "Waiting for submitting answer")
        
        cancellable = viewModel?.$question
            .sink { _ in
                exp.fulfill()
            }
        
        await fulfillment(of: [exp], timeout: 2)
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
