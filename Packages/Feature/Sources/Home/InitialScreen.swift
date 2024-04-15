import SwiftUI

public struct InitialScreen: View {
    private let onStartPress: () -> Void
    
    public init(onStartPress: @escaping () -> Void) {
        self.onStartPress = onStartPress
    }
    
    public var body: some View {
        VStack {
            Text("Welcome")
                .font(.largeTitle)
                .bold()
            Text("Press the button to start survey")
                .font(.callout)
                .foregroundStyle(.gray)
                .padding(.bottom, 64)
            
            NavigationLink(value: "New") {
                Button {
                    onStartPress()
                } label: {
                    Text("Start Survey")
                        .padding(.horizontal, 24)
                        .padding(.vertical, 4)
                }
                .buttonStyle(.borderedProminent)
                .accessibilityIdentifier("StartButton")
            }
        }
    }
}

#Preview {
    InitialScreen{}
}
