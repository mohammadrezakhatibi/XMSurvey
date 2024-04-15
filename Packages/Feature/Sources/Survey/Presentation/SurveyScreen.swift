import SwiftUI

public struct SurveyScreen: View {
    @ObservedObject var viewModel: SurveyViewModel
    
    public init(viewModel: SurveyViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        switch viewModel.viewState {
        case .ready:
            content(with: viewModel.survey)
            
        case .loading:
            ProgressView {
                Text("Fetching...")
            }
            .task {
                await viewModel.startSurvey()
            }
        case .error(let error):
            Text(error)
        }
    }
    
    private func content(with survey: [QuestionViewModel]) -> some View {
        VStack {
            Text(viewModel.numberOfSubmittedTitle)
                .padding()
                .frame(maxWidth: .infinity)
                .font(.callout)
            
            TabView(selection: $viewModel.index) {
                ForEach(survey, id: \.question.id) { question in
                    QuestionView(
                        viewModel: question
                    )
                    .highPriorityGesture(DragGesture())
                }
            }
        }
        #if os(iOS)
        .tabViewStyle(.page)
        #endif
        .animation(.easeInOut, value: viewModel.index)
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.previousQuestion()
                } label: {
                    Text("Previous")
                }
                .disabled(viewModel.startOfQuestion)
                .accessibilityIdentifier("PreviousQuestionButton")
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.nextQuestion()
                } label: {
                    Text("Next")
                }
                .disabled(viewModel.endOfQuestion)
                .accessibilityIdentifier("NextQuestionButton")
            }
            #elseif os(macOS)
            ToolbarItem(placement: .primaryAction) {
                Button {
                    viewModel.previousQuestion()
                } label: {
                    Text("Previous")
                }
                .disabled(viewModel.startOfQuestion)
                .accessibilityIdentifier("PreviousQuestionButton")
            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    viewModel.nextQuestion()
                } label: {
                    Text("Next")
                }
                .disabled(viewModel.endOfQuestion)
                .accessibilityIdentifier("NextQuestionButton")
            }
            #endif
        }
        .navigationTitle(viewModel.screenTitle)
    }
}

#Preview {
    SurveyScreen(viewModel: .init(dataSource: MockSurveyDataSource()))
}
