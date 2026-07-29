import SwiftUI

// MARK: - Input Type

public enum InputType: String, CaseIterable, Sendable {
    case text
    case password
    case email
    case number
    case url
    case search
}

// MARK: - Input

/// A shadcn-styled text input. Corresponds to `<Input>` in shadcn/ui.
///
/// Supports placeholder, focus ring animation, disabled/invalid states, and input type.
///
/// Usage:
/// ```swift
/// @State var text = ""
/// Input("Enter name", text: $text)
/// Input("Password", text: $password, type: .password)
/// ```
public struct Input: View {
    @Environment(\.shadcnToken) private var token
    @Environment(\.isEnabled) private var isEnabled

    let placeholder: String
    @Binding var text: String
    let isInvalid: Bool
    let type: InputType

    @FocusState private var isFocused: Bool

    public init(
        _ placeholder: String = "",
        text: Binding<String>,
        isInvalid: Bool = false,
        type: InputType = .text
    ) {
        self.placeholder = placeholder
        self._text = text
        self.isInvalid = isInvalid
        self.type = type
    }

    public var body: some View {
        inputField
            .font(.system(size: 14))
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .frame(height: 32)
            .background(Color.clear)
            .foregroundColor(token.foreground)
            .opacity(isEnabled ? 1 : 0.5)
            .focused($isFocused)
            .clipShape(RoundedRectangle(cornerRadius: token.radius))
            .overlay(borderOverlay)
            .overlay(focusRingOverlay)
            .animation(.easeInOut(duration: 0.15), value: isFocused)
    }

    @ViewBuilder
    private var inputField: some View {
        switch type {
        case .text:
            TextField(placeholder, text: $text)
        case .password:
            SecureField(placeholder, text: $text)
        case .email:
            TextField(placeholder, text: $text)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocorrectionDisabled()
                #if !os(macOS)
                .textInputAutocapitalization(.never)
                #endif
        case .number:
            TextField(placeholder, text: $text)
                .keyboardType(.decimalPad)
        case .url:
            TextField(placeholder, text: $text)
                .keyboardType(.URL)
                .textContentType(.URL)
                .autocorrectionDisabled()
                #if !os(macOS)
                .textInputAutocapitalization(.never)
                #endif
        case .search:
            TextField(placeholder, text: $text)
                .autocorrectionDisabled()
        }
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
        if isFocused {
            RoundedRectangle(cornerRadius: token.radius)
                .strokeBorder(
                    isInvalid
                        ? token.destructive.opacity(0.2)
                        : token.ring.opacity(0.5),
                    lineWidth: 3
                )
        }
    }
}
