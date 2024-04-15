import SwiftUI

struct SurveyScreen: View {
    var body: some View {
        VStack {
            Text("Title")
                .padding()
                .frame(maxWidth: .infinity)
                .font(.callout)
            
            TabView {
                ForEach(0...10, id: \.self) { question in
                    QuestionView()
                    .highPriorityGesture(DragGesture())
                }
            }
            #if os(iOS)
            .tabViewStyle(.page(indexDisplayMode: .never))
            #endif
        }
        #if os(iOS)
        .tabViewStyle(.page)
        #endif
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // Previous
                } label: {
                    Text("Previous")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // Next
                } label: {
                    Text("Next")
                }
            }
            #elseif os(macOS)
            ToolbarItem(placement: .automatic) {
                Button {
                    // Previous
                } label: {
                    Text("Previous")
                }
            }
            ToolbarItem(placement: .automatic) {
                Button {
                    // Next
                } label: {
                    Text("Next")
                }
            }
            #endif
        }
        .navigationTitle("Question 1/10")
    }
}

#Preview {
    SurveyScreen()
}
