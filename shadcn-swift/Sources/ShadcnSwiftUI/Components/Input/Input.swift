import SwiftUI

// MARK: - Input

/// A shadcn-styled text input. Corresponds to `<Input>` in shadcn/ui.
///
/// Supports placeholder, focus ring animation, and disabled/invalid states.
///
/// Usage:
/// ```swift
/// @State var text = ""
/// Input("Enter name", text: $text)
/// ```
public struct Input: View {
    @Environment(\.shadcnToken) private var token
    @Environment(\.isEnabled) private var isEnabled

    let placeholder: String
    @Binding var text: String
    let isInvalid: Bool

    @FocusState private var isFocused: Bool
    @State private var ringOpacity: Double = 0

    public init(
        _ placeholder: String = "",
        text: Binding<String>,
        isInvalid: Bool = false
    ) {
        self.placeholder = placeholder
        self._text = text
        self.isInvalid = isInvalid
    }

    public var body: some View {
        TextField(placeholder, text: $text)
            .font(.system(size: 14))
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .frame(height: 32)
            .background(Color.clear)
            .foregroundColor(token.foreground)
            .opacity(isEnabled ? 1 : 0.5)
            .focused($isFocused)
            .onChange(of: isFocused) { _, focused in
                withAnimation(.easeInOut(duration: 0.15)) {
                    ringOpacity = focused ? 1 : 0
                }
            }
            .overlay(borderOverlay)
            .clipShape(RoundedRectangle(cornerRadius: token.radius))
            .overlay(focusRingOverlay)
            .animation(.easeInOut(duration: 0.15), value: isFocused)
    }

    private var borderColor: Color {
        if isInvalid { return token.destructive }
        if isFocused { return token.ring }
        return token.input
    }

    @ViewBuilder
    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: token.radius)
            .strokeBorder(borderColor, lineWidth: 1)
    }

    @ViewBuilder
    private var focusRingOverlay: some View {
        RoundedRectangle(cornerRadius: token.radius)
            .strokeBorder(isInvalid
                ? token.destructive.opacity(0.2 * ringOpacity)
                : token.ring.opacity(0.5 * ringOpacity),
                lineWidth: isFocused ? 3 : 0
            )
    }
}
