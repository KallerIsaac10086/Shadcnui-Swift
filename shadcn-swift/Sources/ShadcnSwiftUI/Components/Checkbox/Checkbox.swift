import SwiftUI

/// Checkbox control. Corresponds to `<Checkbox>` in shadcn/ui.
///
/// Checked state shows a checkmark icon. 16pt × 16pt, 4pt corner radius.
///
/// Usage: `@State var checked = false; Checkbox(isChecked: $checked)`
public struct Checkbox: View {
    @Environment(\.shadcnToken) private var token
    @Environment(\.isEnabled) private var isEnabled

    @Binding var isChecked: Bool

    public init(isChecked: Binding<Bool>) {
        self._isChecked = isChecked
    }

    public var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.15)) { isChecked.toggle() }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(isChecked ? token.primary : Color.clear)
                    .frame(width: 16, height: 16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .strokeBorder(isChecked ? token.primary : token.border, lineWidth: 1)
                    )
                if isChecked {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(token.primaryForeground)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .buttonStyle(.borderless)
        .frame(width: 16, height: 16)
        .opacity(isEnabled ? 1 : 0.5)
    }
}

public extension Checkbox {
    init(_ label: String, isChecked: Binding<Bool>) {
        self._isChecked = isChecked
    }
}
