import SwiftUI

public struct Banner: ViewModifier {
    public enum Kind {
        case success
        case failure
    }
    
    @Binding var isPresented: Bool
    private let title: Text
    private let action: (() -> Void)?
    private let kind: Kind

    public init(isPresented: Binding<Bool>,
                kind: Kind,
                title: String,
                action: (() -> Void)? = nil)
    {
        _isPresented = isPresented
        self.title = Text(title).font(.headline).bold()
        self.kind = kind
        self.action = action
    }

    public func body(content: Content) -> some View {
        ZStack {
            content
            VStack {
                snackBar
                    .padding(.horizontal)
                Spacer()
            }
            .animation(.default, value: isPresented)
        }
        .onDisappear {
            isPresented = false
        }
    }

    private var snackBar: some View {
        VStack {
            if isPresented {
                HStack {
                    title
                    Spacer()
                    if action != nil {
                        Button {
                            isPresented = false
                            action?()
                        } label: {
                            Text("Retry")
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .foregroundStyle(.white)
                .padding()
                .background(kind == .success ? .green : .red)
                .opacity(isPresented ? 1 : 0)
                .transition(.opacity)
                .cornerRadius(8)
                .onAppear {
                    Task { @MainActor in
                        try? await Task.sleep(for: .seconds(2))
                        self.isPresented = false
                    }
                }
                .onTapGesture {
                    isPresented = false
                }
            }
        }
    }
}

public extension View {
    /// Adds a snackBar to the view
    /// - Parameters:
    ///   - isShowing: Binding that lets you control the `show` state of the `SnackBar`
    ///   - title: The title of snack bar
    ///   - action: The action you want to perform when the user touches the snack bar (optional)
    func banner(isPresented: Binding<Bool>, kind: Banner.Kind, title: String, action: (() -> Void)? = nil) -> some View {
        modifier(Banner(isPresented: isPresented, kind: kind, title: title, action: action))
    }
}