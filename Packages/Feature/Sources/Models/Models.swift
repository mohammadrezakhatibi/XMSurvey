import Foundation

public struct Survey {
    public var id: UUID
    public var questions: [Question]
    
    public init(questions: [Question]) {
        self.id = UUID()
        self.questions = questions
    }
}

#if DEBUG
public extension Survey {
    static var example: Survey {
        Survey(questions: [.example])
    }
}
#endif
