import SwiftUI

/// Form label. Corresponds to `<Label>` in shadcn/ui.
///
/// Auto-dims when wrapped in a disabled container.
public struct ShadcnLabel: View {
    @Environment(\.shadcnToken) private var token
    @Environment(\.isEnabled) private var isEnabled

    let text: String
    var required: Bool = false

    public init(_ text: String, required: Bool = false) {
        self.text = text
        self.required = required
    }

    public var body: some View {
        HStack(spacing: 4) {
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(token.foreground)
            if required {
                Text("*")
                    .foregroundColor(token.destructive)
            }
        }
        .opacity(isEnabled ? 1 : 0.5)
    }
}
