import SwiftUI

/// Checkbox control. Corresponds to `<Checkbox>` in shadcn/ui.
///
/// Checked state shows a checkmark icon. 16pt × 16pt, 4pt corner radius.
/// Supports indeterminate (tri-state) via optional `isIndeterminate`.
///
/// Usage:
/// ```swift
/// @State var checked = false
/// Checkbox(isChecked: $checked)
///
/// // Indeterminate mode
/// Checkbox(isChecked: $checked, isIndeterminate: true)
/// ```
public struct Checkbox: View {
    @Environment(\.shadcnToken) private var token
    @Environment(\.isEnabled) private var isEnabled

    @Binding var isChecked: Bool
    let isIndeterminate: Bool

    public init(isChecked: Binding<Bool>, isIndeterminate: Bool = false) {
        self._isChecked = isChecked
        self.isIndeterminate = isIndeterminate
    }

    public var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.15)) { isChecked.toggle() }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill((isChecked || isIndeterminate) ? token.primary : Color.clear)
                    .frame(width: 16, height: 16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .strokeBorder((isChecked || isIndeterminate) ? token.primary : token.border, lineWidth: 1)
                    )
                if isIndeterminate {
                    Capsule()
                        .fill(token.primaryForeground)
                        .frame(width: 8, height: 2)
                        .transition(.scale.combined(with: .opacity))
                } else if isChecked {
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
    init(_ label: String, isChecked: Binding<Bool>, isIndeterminate: Bool = false) {
        self._isChecked = isChecked
        self.isIndeterminate = isIndeterminate
    }
}
