import Foundation
import Survey

final class SurveyViewModelFactory {
    static func makeViewModel() -> SurveyViewModel {
        SurveyViewModel(dataSource: makeDataSource())
    }
    
    static func makeDataSource() -> SurveyDataSource {
        RemoteSurveyDataSource(client: URLSession.shared)
    }
}
