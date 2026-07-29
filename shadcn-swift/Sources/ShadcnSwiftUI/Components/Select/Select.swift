import SwiftUI

// MARK: - Select

/// A dropdown select. Corresponds to `<Select>` in shadcn/ui.
///
/// Uses native SwiftUI `Menu` for reliable dropdown behavior.
///
/// Usage:
/// ```swift
/// @State var selection = "light"
/// Select(placeholder: "Theme", selection: $selection) {
///     SelectItem("Light", value: "light")
///     SelectItem("Dark", value: "dark")
/// }
/// ```
public struct Select<Value: Hashable & Sendable, Content: View>: View {
    @Environment(\.shadcnToken) private var token

    let placeholder: String
    @Binding var selection: Value
    @ViewBuilder let content: () -> Content

    public init(
        placeholder: String = "",
        selection: Binding<Value>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.placeholder = placeholder
        self._selection = selection
        self.content = content
    }

    public var body: some View {
        Menu {
            content()
        } label: {
            HStack {
                Text("\(String(describing: selection))")
                    .font(.system(size: 14))
                    .foregroundColor(token.foreground)
                Spacer()
                Image(systemName: "chevron.down")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(token.mutedForeground)
            }
            .frame(height: 36)
            .padding(.horizontal, 12)
            .background(token.card)
            .clipShape(RoundedRectangle(cornerRadius: token.radius))
            .overlay(RoundedRectangle(cornerRadius: token.radius).strokeBorder(token.border, lineWidth: 1))
            .contentShape(Rectangle())
        }
        .environment(\.selectBinding, SelectBinding { selection = $0 as! Value })
        .environment(\.selectCurrentValue, selection)
    }
}

// MARK: - Environment

struct SelectBinding: Sendable {
    let select: @Sendable (AnyHashable) -> Void
}
private struct SelectBindingKey: EnvironmentKey { static let defaultValue = SelectBinding { _ in } }
private struct SelectCurrentValueKey: EnvironmentKey { nonisolated(unsafe) static let defaultValue: AnyHashable = "" }

extension EnvironmentValues {
    var selectBinding: SelectBinding {
        get { self[SelectBindingKey.self] }
        set { self[SelectBindingKey.self] = newValue }
    }
    var selectCurrentValue: AnyHashable {
        get { self[SelectCurrentValueKey.self] }
        set { self[SelectCurrentValueKey.self] = newValue }
    }
}

// MARK: - SelectItem

public struct SelectItem<Value: Hashable & Sendable>: View {
    @Environment(\.selectBinding) private var selectBinding
    @Environment(\.selectCurrentValue) private var currentValue

    let label: String
    let value: Value

    public init(_ label: String, value: Value) {
        self.label = label; self.value = value
    }

    private var isSelected: Bool { (currentValue.base as? Value) == value }

    public var body: some View {
        Button {
            selectBinding.select(value)
        } label: {
            if isSelected {
                Label(label, systemImage: "checkmark")
            } else {
                Text(label)
            }
        }
    }
}

// MARK: - SelectGroup / Label / Separator

public struct SelectGroup<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View { Section { content() } }
}

public struct SelectLabel: View {
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text).font(.system(size: 12, weight: .semibold))
    }
}

public struct SelectSeparator: View {
    public init() {}
    public var body: some View { Divider() }
}
