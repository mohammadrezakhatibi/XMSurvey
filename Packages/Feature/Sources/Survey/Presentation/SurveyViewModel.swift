import Foundation
import Models
import Combine

public final class SurveyViewModel: ObservableObject {
    @Published public var index: Int = 1
    @Published private(set) public var viewState: ViewState = .loading
    @Published private var numberOfSubmitted: Int = 0
    private var cancellable: Set<AnyCancellable> = []
    private let dataSource: SurveyDataSource
    
    public init(dataSource: SurveyDataSource) {
        self.dataSource = dataSource
    }
    
    @MainActor
    public func start() async {
        let result =  await dataSource.start()
        switch result {
        case .success(let survey):
            let viewModels = survey.questions.map { [dataSource] in
                let viewModel = QuestionViewModel(dataSource: dataSource, question: $0)
                viewModel.$question
                    .dropFirst()
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] success in
                        self?.numberOfSubmitted += success.hasAnswer ? 1 : 0
                    }
                    .store(in: &cancellable)
                return viewModel
            }
            viewState = .ready(viewModels)
        case .failure(let failure):
            viewState = .error(failure.localizedDescription)
        }
    }
}

extension SurveyViewModel {
    public var survey: [QuestionViewModel] {
        guard case let .ready(survey) = viewState else {
            return []
        }
        return survey
    }
    
    public var endOfQuestion: Bool {
        return index == survey.count
    }
    
    public var startOfQuestion: Bool {
        index == 1
    }
    
    public var screenTitle: String {
        return "Questions \(index)/\(survey.count)"
    }
    
    public var numberOfSubmittedTitle: String {
        return "Questions Submitted: \(numberOfSubmitted)"
    }
    
    public func nextQuestion() {
        index += 1
    }
    
    public func previousQuestion() {
        index -= 1
    }
}

extension SurveyViewModel {
    public enum ViewState {
        case ready([QuestionViewModel])
        case loading
        case error(String)
    }
}
