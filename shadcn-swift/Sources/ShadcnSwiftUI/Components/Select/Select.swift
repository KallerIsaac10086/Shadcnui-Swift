import SwiftUI

// MARK: - Select

/// A dropdown select picker. Corresponds to `<Select>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// @State var selection = "light"
/// Select(placeholder: "Theme", selection: $selection) {
///     SelectItem("Light", value: "light")
///     SelectItem("Dark", value: "dark")
///     SelectItem("System", value: "system")
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
        }
    }
}

// MARK: - SelectItem

public struct SelectItem<Value: Hashable & Sendable>: View {
    @Environment(\.shadcnToken) private var token

    let label: String
    let value: Value
    @Binding var selection: Value

    public init(_ label: String, value: Value, selection: Binding<Value>) {
        self.label = label
        self.value = value
        self._selection = selection
    }

    public var body: some View {
        Button {
            selection = value
        } label: {
            HStack {
                Text(label)
                if value == selection {
                    Spacer()
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                }
            }
        }
    }
}

// MARK: - SelectGroup

public struct SelectGroup<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View { Section { content() } }
}

// MARK: - SelectLabel

public struct SelectLabel: View {
    @Environment(\.shadcnToken) private var token
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text).font(.system(size: 12, weight: .semibold)).foregroundColor(token.mutedForeground)
    }
}

// MARK: - SelectSeparator

public struct SelectSeparator: View {
    @Environment(\.shadcnToken) private var token
    public init() {}
    public var body: some View { Divider().overlay(token.border) }
}
