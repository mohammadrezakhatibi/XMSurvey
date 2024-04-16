import SwiftUI

/// A generic error view
///
/// - Parameters:
///   - label: label for the view
///   - buttonTitle: Retry button title
///   - retryAction: Retry button action
public struct ErrorView<Content>: View where Content: View {
    public typealias Action = () -> Void
    @ViewBuilder let label: Content
    private let retryAction: (Action)
    private let buttonLabel: Content
    
    public init(
        @ViewBuilder label: @escaping () -> Content,
        @ViewBuilder buttonLabel: @escaping () -> Content,
        retryAction: @escaping (Action)
    ) {
        self.label = label()
        self.retryAction = retryAction
        self.buttonLabel = buttonLabel()
    }
    
    public var body: some View {
        VStack {
            Spacer()
            Image(systemName: "exclamationmark.circle")
                .font(.system(size: 40))
                .foregroundStyle(.gray.opacity(0.8))
            label
                .font(.callout)
                .foregroundStyle(.gray)
                .padding(.vertical)
                .multilineTextAlignment(.center)
            Spacer()
            Spacer()
            Button(action: {
                retryAction()
            }, label: {
                buttonLabel
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.borderedProminent)
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("ErrorView")
        .padding(.horizontal, 32)
    }
}

#Preview {
    ErrorView(
        label: {
            Text("This is a sample error message")
        },
        buttonLabel: {
            Text("Fetch Data Again")
        },
        retryAction: {
            // Ignore
        }
    )

}
