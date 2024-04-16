import SwiftUI
import Home
import Survey

public struct AppScreen: View {
    @State private var path: [Screen] = []
    
    public init() {}
    
    public var body: some View {
        
        NavigationStack(path: $path) {
            InitialScreen {
                path.append(.survey)
            }
            .navigationDestination(for: Screen.self) { path in
                switch path {
                case .survey:
                    SurveyScreen(viewModel: SurveyViewModelFactory.makeViewModel())
                }
            }
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .navigationTitle("Survey")
        }
    }
}

extension AppScreen {
    enum Screen {
        case survey
    }
}

#Preview {
    AppScreen()
}
