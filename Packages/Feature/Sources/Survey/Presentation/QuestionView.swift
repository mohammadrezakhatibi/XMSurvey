import SwiftUI

struct QuestionView: View {
    @ObservedObject var viewModel: QuestionViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                Text(viewModel.question.question)
                    .font(.title2)
                    .bold()
                    .padding(.vertical, 0)
                    .accessibilityIdentifier("QuestionLabel")
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.secondary.opacity(0.15))
                    TextEditor(text: $viewModel.answer)
                        .scrollContentBackground(.hidden)
                        .background(.clear)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .foregroundStyle(.primary)
                        .disabled(viewModel.question.hasAnswer)
                }
                .frame(height: 150)
            }
            .padding(.horizontal, 16)
            
            Button {
                Task {
                    await viewModel.submitAnswer()
                }
                
            } label: {
                HStack {
                    if viewModel.viewState == .submitting {
                        ProgressView()
                            .tint(.white)
                            .padding(.trailing, 4)
                    }
                    Text(viewModel.question.hasAnswer ? "Already Submitted" : "Submit")
                        
                }
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
            
            }
            .disabled(viewModel.submitDisabled)
            .padding()
            .buttonStyle(.borderedProminent)
            .accessibilityIdentifier("SubmitButton")
        }
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

#Preview {
    NavigationStack {
        QuestionView(
            viewModel: QuestionViewModel(
                dataSource: MockSurveyDataSource(),
                question: .example
            )
        )
    }
}
