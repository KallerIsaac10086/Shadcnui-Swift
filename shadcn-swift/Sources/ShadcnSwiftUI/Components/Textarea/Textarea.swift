import SwiftUI

/// Multi-line text input. Corresponds to `<Textarea>` in shadcn/ui.
///
/// Usage: `@State var text = ""; Textarea("Enter text", text: $text)`
public struct Textarea: View {
    @Environment(\.shadcnToken) private var token
    @Environment(\.isEnabled) private var isEnabled

    let placeholder: String
    @Binding var text: String
    let minHeight: CGFloat

    public init(_ placeholder: String = "", text: Binding<String>, minHeight: CGFloat = 80) {
        self.placeholder = placeholder
        self._text = text
        self.minHeight = minHeight
    }

    public var body: some View {
        TextEditor(text: $text)
            .font(.system(size: 14))
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .frame(minHeight: minHeight)
            .foregroundColor(token.foreground)
            .opacity(isEnabled ? 1 : 0.5)
            .clipShape(RoundedRectangle(cornerRadius: token.radius))
            .overlay(
                RoundedRectangle(cornerRadius: token.radius)
                    .strokeBorder(token.border, lineWidth: 1)
            )
            .overlay(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.system(size: 14))
                        .foregroundColor(token.mutedForeground)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 16)
                        .allowsHitTesting(false)
                }
            }
    }
}
