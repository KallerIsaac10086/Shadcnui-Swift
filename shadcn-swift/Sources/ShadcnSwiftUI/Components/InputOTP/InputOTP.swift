import SwiftUI

// MARK: - InputOTP

/// A 6-digit one-time password input. Corresponds to `<InputOTP>` in shadcn/ui.
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
    @FocusState private var focusedIndex: Int?

    public init(code: Binding<String>, length: Int = 6) {
        self._code = code
        self.length = length
    }

    public var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<length, id: \.self) { i in
                let char = i < code.count ? String(code[code.index(code.startIndex, offsetBy: i)]) : ""
                ZStack {
                    RoundedRectangle(cornerRadius: token.radius)
                        .fill(token.card)
                        .frame(width: 44, height: 52)
                        .overlay(
                            RoundedRectangle(cornerRadius: token.radius)
                                .strokeBorder(focusedIndex == i ? token.ring : token.border, lineWidth: focusedIndex == i ? 2 : 1)
                        )

                    if char.isEmpty && focusedIndex != i {
                        Circle().fill(token.muted).frame(width: 8, height: 8)
                    } else {
                        Text(char)
                            .font(.system(size: 20, weight: .semibold, design: .monospaced))
                            .foregroundColor(token.foreground)
                    }
                }
                .overlay(
                    TextField("", text: Binding(
                        get: { code },
                        set: { handleInput($0) }
                    ))
                    #if !os(macOS)
                    .keyboardType(.numberPad)
                    #endif
                    .focused($focusedIndex, equals: i)
                    .opacity(0)
                    .frame(width: 0, height: 0)
                )
                .onTapGesture { focusedIndex = i }
            }
        }
        .opacity(isEnabled ? 1 : 0.5)
        .onAppear { focusedIndex = 0 }
    }

    private func handleInput(_ newValue: String) {
        let digits = newValue.filter { $0.isNumber }
        if digits.count <= length {
            code = String(digits.prefix(length))
            if code.count < length { focusedIndex = code.count }
        }
    }
}
