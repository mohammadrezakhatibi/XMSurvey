import Foundation
import Models

public final class QuestionViewModel: ObservableObject {
    public enum ViewState {
        case idle
        case submitting
        case success
        case failure
    }
    private var dataSource: SurveyDataSource
    @Published private(set) public var question: Question
    @Published public var viewState: ViewState = .idle
    @Published public var answer: String = ""
    
    public var submitDisabled: Bool {
        answer.isEmpty || question.hasAnswer || viewState == .submitting
    }
    
    public init(dataSource: SurveyDataSource, question: Question) {
        self.dataSource = dataSource
        self.question = question
    }
    
    @MainActor
    public func submitAnswer() async {
        viewState = .submitting
        let result = await dataSource.submit(answer: Answer(id: question.id, answer: answer))
        
        switch result {
        case .success(_):
            question.answer = answer
            viewState = .success
        case .failure(_):
            viewState = .failure
        }
    }
}
