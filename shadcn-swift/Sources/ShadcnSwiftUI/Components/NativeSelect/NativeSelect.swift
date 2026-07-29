import SwiftUI

// MARK: - NativeSelect

/// A native-styled dropdown select using SwiftUI `Menu`.
///
/// Corresponds to `<NativeSelect>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// @State var selection = "light"
/// NativeSelect(placeholder: "Theme", selection: $selection, options: [
///     ("Light", "light"),
///     ("Dark", "dark"),
///     ("System", "system"),
/// ])
/// ```
@available(iOS 16.0, macOS 13.0, *)
public struct NativeSelect<Value: Hashable & Sendable>: View {
    @Environment(\.shadcnToken) private var token

    let placeholder: String
    @Binding var selection: Value
    let options: [(label: String, value: Value)]

    public init(
        placeholder: String = "",
        selection: Binding<Value>,
        options: [(label: String, value: Value)]
    ) {
        self.placeholder = placeholder
        self._selection = selection
        self.options = options
    }

    private var selectedLabel: String? {
        options.first { $0.value == selection }?.label
    }

    public var body: some View {
        Menu {
            ForEach(options, id: \.value) { option in
                Button {
                    selection = option.value
                } label: {
                    if option.value == selection {
                        Label(option.label, systemImage: "checkmark")
                    } else {
                        Text(option.label)
                    }
                }
            }
        } label: {
            HStack {
                Text(selectedLabel ?? placeholder)
                    .foregroundColor(selectedLabel == nil ? token.mutedForeground : token.foreground)
                Spacer()
                Image(systemName: "chevron.down")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(token.mutedForeground)
            }
            .font(.system(size: 14))
            .frame(height: 32)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(token.card)
            .foregroundColor(token.foreground)
            .clipShape(RoundedRectangle(cornerRadius: token.radius))
            .overlay(
                RoundedRectangle(cornerRadius: token.radius)
                    .strokeBorder(token.border, lineWidth: 1)
            )
        }
    }
}
