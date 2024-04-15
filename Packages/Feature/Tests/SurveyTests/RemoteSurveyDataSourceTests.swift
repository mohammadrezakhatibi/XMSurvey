import XCTest
import Survey
import HTTPClient
import TestHelpers
import Models

final class RemoteSurveyDataSourceTests: XCTestCase {
    func test_dataSource_doseNotRequestOnInstantiation(){
        let (_, client) = makeSUT()
        XCTAssertEqual(client.urls, [])
    }
    
    func test_start_requestsSurvey() async {
        let (sut, client) = makeSUT()
        
        _ = await sut.start()
        
        XCTAssertEqual(client.urls, [SurveyEndPoints.list.url])
    }
    
    func test_start_deliversErrorOnHTPPClientFailure() async {
        let (sut, _) = makeSUT(result: .failure(anyError()))
        let result = await sut.start()
        if case .failure(let error) = result {
            XCTAssertEqual(error as? RemoteSurveyDataSource.Error, .server)
        } else {
            XCTFail("Expected failure, got success")
        }
    }
    
    func test_start_deliversErrorOnInvalidData() async {
        let (sut, _) = makeSUT(result: .success((anyData(), successHTTPResponse())))
        let result = await sut.start()
        
        if case .failure(let error) = result {
            XCTAssertEqual(error as? RemoteSurveyDataSource.Error, .decoding)
        } else {
            XCTFail("Expected failure, got success")
        }
    }
    
    func test_start_deliversSurveyOn200SuccessfulHPPTClient() async {
        let (sut, _) = makeSUT(result: .success((makeSurveyJSON(), successHTTPResponse())))
        
        let result = await sut.start()
        
        if case .success(let survey) = result {
            XCTAssertEqual(survey.questions.first?.id, 1)
            XCTAssertEqual(survey.questions.first?.question, "Test Question 1")
        } else {
            XCTFail("Expected success, got failure")
        }
    }
    
    func test_submit_callsSubmit() async {
        let (sut, client) = makeSUT()
        _ = await sut.submit(answer: Answer(id: 1, answer: "Answer"))

        XCTAssertEqual(client.urls, [SurveyEndPoints.submit.url])
    }
    
    func test_submit_successful() async {
        let (sut, _) = makeSUT(result: .success((makeSurveyJSON(), successHTTPResponse())))
        let result = await sut.submit(answer: Answer(id: 1, answer: "Answer"))

        if case .failure(_) = result {
            XCTFail("Expected success, got failure")
        }
    }
    
    // MARK: Helpers
    
    private func makeSUT(
        result: (Result<(Data?, HTTPURLResponse?), Error>) = .success((anyData(), anyHTTPURLResponse())),
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: RemoteSurveyDataSource, client: HTTPClientSpy) {
        let client = HTTPClientSpy(result: result)
        let sut = RemoteSurveyDataSource(client: client)
        
        trackForMemoryLeaks(client)
        trackForMemoryLeaks(sut)
        return (sut, client)
    }
    
    private final class HTTPClientSpy: HTTPClient {
        private(set) var urls = [URL]()
        private let result: HTTPClient.Result
        
        init(result: HTTPClient.Result) {
            self.result = result
        }
        
        func get(url: URL) async -> HTTPClient.Result {
            urls.append(url)
            return result
        }
        
        func post<T>(url: URL, body: T) async -> HTTPClient.Result {
            urls.append(url)
            return result
        }
    }
    
    private func makeSurveyJSON() -> Foundation.Data {
        let json = [
            [
                "id": 1,
                "question": "Test Question 1"
            ],
            [
                "id": 2,
                "question": "What is your favourite food?"
            ]
        ]
    
        
        return try! JSONSerialization.data(withJSONObject: json)
    }
}
