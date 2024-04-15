import Foundation

public struct Answer: Encodable {
    public let id: Int
    public let answer: String
    
    public init(id: Int, answer: String) {
        self.id = id
        self.answer = answer
    }
}
