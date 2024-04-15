import XCTest
import Survey
import Models

final class SurveyDataMapperTests: XCTestCase {
    func test_map_throwsErrorOnNon2xxHTTPResponse() throws {
        let json = makeItemsJSON([])
        let samples = [199, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try SurveyDataMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try SurveyDataMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversNoItemsWithEmptyJSONList() throws {
        let emptyListJSON = makeItemsJSON([])

        let result = try SurveyDataMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))

        XCTAssertEqual(result.questions, [])
    }
    
    func test_map_deliversItemsWithJSONItems() throws {
        let item1 = makeItem(
            id: 1,
            question: "Test Question 1"
        )
        
        let item2 = makeItem(
            id: 2,
            question: "Test Question 2"
        )
        
        let json = makeItemsJSON([item1.json, item2.json])
        
        let result = try SurveyDataMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result.questions, [item1.model, item2.model])
    }
    
    
    // MARK: - Helpers
    
    private func makeItem(
        id: Int,
        question: String
    ) -> (model: Question, json: [String: Any]) {
        
        let item = Question(id: id, question: question)
        
        let json = [
            "id": id,
            "question": question
        ].compactMapValues { $0 }
        
        return (item, json)
    }
    
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = items
        return try! JSONSerialization.data(withJSONObject: json)
    }
}

extension Survey: Equatable {
    public static func == (lhs: Survey, rhs: Survey) -> Bool {
        lhs.id == rhs.id
    }
}
