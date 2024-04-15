import XCTest
import Survey
import HTTPClient
import TestHelpers

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
    
    // MARK: Helpers
    
    private func makeSUT(
        result: (Result<(Data?, HTTPURLResponse?), Error>) = .success((anyData(), anyHTTPURLResponse())),
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: RemoteSurveyDataSource, client: HTTPClientSpy) {
        let client = HTTPClientSpy(result: result)
        let sut = RemoteSurveyDataSource(client: client)
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
}
