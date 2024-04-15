import Foundation
import Models

public final class SurveyDataMapper {
    private struct Root: Decodable, Hashable {
        let id: Int
        let question: String
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data?, from response: HTTPURLResponse?) throws -> Survey {
        guard let data, let response, response.statusCode == 200 else {
            throw Error.invalidData
        }
        
        guard isOK(response), let root = try? JSONDecoder().decode([Root].self, from: data) else {
            throw Error.invalidData
        }
        
        let questions = root.map { question in
            Question(id: question.id, question: question.question, answer: nil)
        }
        return Survey(questions: questions)
    }
    
    private static func isOK(_ response: HTTPURLResponse) -> Bool {
        200 == response.statusCode
    }
}
