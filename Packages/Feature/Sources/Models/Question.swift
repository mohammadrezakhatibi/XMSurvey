import Foundation

public struct Question: Decodable, Hashable {
    public let id: Int
    public let question: String
    public var answer: String?
    
    public init(id: Int, question: String, answer: String? = nil) {
        self.id = id
        self.question = question
        self.answer = answer
    }
    
    public var hasAnswer: Bool {
        answer != nil
    }
}

#if DEBUG
public extension Question {
    static func example(id: Int = 1) -> Question {
        Question(id: id, question: "What's your favourite food")
    }
}
#endif
