import SwiftUI

// MARK: - InputOTP

/// A one-time password input with individual digit slots.
/// Corresponds to `<InputOTP>` in shadcn/ui.
///
/// Uses pure SwiftUI `onKeyPress` for keyboard input — **no** native
/// `TextField` or `NSTextField` control ever enters the view tree.
/// Backspace, arrow keys, and digit filtering are all handled manually.
///
/// Usage:
/// ```swift
/// @State var code = ""
/// InputOTP(code: $code, length: 6)
/// ```
public struct InputOTP: View {
    @Environment(\.shadcnToken) private var token
    @Environment(\.isEnabled) private var isEnabled

    @Binding var code: String
    let length: Int

    @FocusState private var isFocused: Bool
    @State private var inputText: String = ""
    @State private var caretOn: Bool = false

    public init(code: Binding<String>, length: Int = 6) {
        self._code = code
        self.length = length
    }

    public var body: some View {
        HStack(spacing: 8) {
            ForEach(0 ..< length, id: \.self) { i in
                slotView(index: i)
            }
        }
        .focusable(true)
        .focused($isFocused)
        .focusEffectDisabled()
        .onTapGesture { isFocused = true }
        .onAppear {
            inputText = code
            isFocused = true
        }
        .onChange(of: code) { _, newValue in
            let digits = String(newValue.filter(\.isNumber).prefix(length))
            if inputText != digits { inputText = digits }
        }
        .onKeyPress { keyPress in
            handleKeyPress(keyPress)
        }
        .opacity(isEnabled ? 1 : 0.5)
    }

    // MARK: - Slot

    private func slotView(index i: Int) -> some View {
        let char = i < inputText.count
            ? String(inputText[inputText.index(inputText.startIndex, offsetBy: i)])
            : ""
        let isActive = isFocused && i == inputText.count

        return ZStack {
            RoundedRectangle(cornerRadius: token.radius)
                .fill(token.card)
                .frame(width: 36, height: 36)
                .overlay(
                    RoundedRectangle(cornerRadius: token.radius)
                        .strokeBorder(
                            isActive ? token.ring : token.input,
                            lineWidth: isActive ? 2 : 1
                        )
                )

            Group {
                if char.isEmpty {
                    if isActive {
                        Rectangle()
                            .fill(token.foreground)
                            .frame(width: 1, height: 16)
                            .opacity(caretOn ? 1 : 0)
                            .animation(
                                .easeInOut(duration: 0.5).repeatForever(autoreverses: true),
                                value: isActive
                            )
                    } else {
                        Circle()
                            .fill(token.muted)
                            .frame(width: 6, height: 6)
                    }
                } else {
                    Text(char)
                        .font(.system(size: 16, weight: .semibold, design: .monospaced))
                        .foregroundColor(token.foreground)
                }
            }
        }
    }

    // MARK: - Key handling

    private func handleKeyPress(_ keyPress: KeyPress) -> KeyPress.Result {
        switch keyPress.key {
        case .delete, .upArrow, .downArrow, .leftArrow, .rightArrow:
            if keyPress.key == .delete, !inputText.isEmpty {
                inputText.removeLast()
                code = inputText
            }
            return .handled

        default:
            break
        }

        // Filter: only digits, and only up to `length` characters
        if let character = keyPress.characters.first,
           character.isNumber,
           inputText.count < length
        {
            inputText.append(character)
            code = inputText
            return .handled
        }

        // Swallow spaces so they don't toggle focus
        if keyPress.key == .space {
            return .handled
        }

        return .ignored
    }
}
