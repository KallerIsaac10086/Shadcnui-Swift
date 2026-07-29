import SwiftUI

// MARK: - Select

/// A custom dropdown select. Corresponds to `<Select>` in shadcn/ui.
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
    @State private var isOpen = false

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
        VStack(spacing: 0) {
            Button { withAnimation(.easeInOut(duration: 0.15)) { isOpen.toggle() } } label: {
                HStack {
                    Text("\(String(describing: selection))")
                        .font(.system(size: 14))
                        .foregroundColor(token.foreground)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(token.mutedForeground)
                        .rotationEffect(.degrees(isOpen ? 180 : 0))
                        .animation(.easeInOut(duration: 0.15), value: isOpen)
                }
                .frame(height: 36)
                .padding(.horizontal, 12)
                .background(token.card)
                .clipShape(RoundedRectangle(cornerRadius: token.radius))
                .overlay(RoundedRectangle(cornerRadius: token.radius).strokeBorder(isOpen ? token.ring : token.border, lineWidth: 1))
                .contentShape(Rectangle())
            }
            .buttonStyle(.borderless)

            if isOpen {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        content()
                    }
                }
                .frame(maxHeight: 200)
                .padding(.vertical, 4)
                .background(token.popover)
                .clipShape(RoundedRectangle(cornerRadius: token.radius))
                .overlay(RoundedRectangle(cornerRadius: token.radius).strokeBorder(token.border, lineWidth: 1))
                .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
                .transition(.opacity.combined(with: .scale(scale: 0.95, anchor: .top)))
                .onTapGesture { withAnimation(.easeInOut(duration: 0.15)) { isOpen = false } }
            }
        }
        .environment(\.selectBinding, SelectBinding { selection = $0 as! Value; withAnimation(.easeInOut(duration: 0.15)) { isOpen = false } })
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
    @Environment(\.shadcnToken) private var token
    @Environment(\.selectBinding) private var selectBinding
    @Environment(\.selectCurrentValue) private var currentValue

    let label: String
    let value: Value

    public init(_ label: String, value: Value) {
        self.label = label; self.value = value
    }

    private var isSelected: Bool { (currentValue.base as? Value) == value }

    public var body: some View {
        Button { selectBinding.select(value) } label: {
            HStack {
                Text(label).font(.system(size: 14)).foregroundColor(token.foreground)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark").font(.system(size: 12, weight: .bold)).foregroundColor(token.primary)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? token.muted : Color.clear)
            .contentShape(Rectangle())
        }
        .buttonStyle(.borderless)
    }
}

// MARK: - SelectGroup / Label / Separator

public struct SelectGroup<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View { VStack(alignment: .leading, spacing: 0) { content() } }
}

public struct SelectLabel: View {
    @Environment(\.shadcnToken) private var token
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text).font(.system(size: 12, weight: .semibold)).foregroundColor(token.mutedForeground).padding(.horizontal, 12).padding(.vertical, 4)
    }
}

public struct SelectSeparator: View {
    @Environment(\.shadcnToken) private var token
    public init() {}
    public var body: some View { Rectangle().fill(token.border).frame(height: 1) }
}
