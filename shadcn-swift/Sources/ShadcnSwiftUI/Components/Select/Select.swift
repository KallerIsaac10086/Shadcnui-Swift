import SwiftUI

// MARK: - Environment

/// Action dispatched when a SelectItem is tapped.
fileprivate struct SelectAction: Sendable {
    let handler: @Sendable (AnyHashable) -> Void
}

private struct SelectActionKey: EnvironmentKey {
    static let defaultValue = SelectAction { _ in }
}

private struct SelectValueKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue: AnyHashable = ""
}

fileprivate extension EnvironmentValues {
    var selectAction: SelectAction {
        get { self[SelectActionKey.self] }
        set { self[SelectActionKey.self] = newValue }
    }
    var selectValue: AnyHashable {
        get { self[SelectValueKey.self] }
        set { self[SelectValueKey.self] = newValue }
    }
}

// MARK: - Select (Root)

/// A custom dropdown select. Corresponds to `<Select>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// @State var selection = "light"
/// Select(selection: $selection, placeholder: "Theme") {
///     SelectItem("Light", value: "light")
///     SelectItem("Dark", value: "dark")
/// }
/// ```
public struct Select<Value: Hashable & Sendable, Content: View>: View {
    @Environment(\.shadcnToken) private var token

    @Binding var selection: Value
    let placeholder: String
    @ViewBuilder let content: () -> Content
    @State private var isOpen = false

    public init(
        placeholder: String = "",
        selection: Binding<Value>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._selection = selection
        self.placeholder = placeholder
        self.content = content
    }

    public var body: some View {
        ZStack(alignment: .top) {
            // Invisible backdrop when open — tap to dismiss
            if isOpen {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.15)) { isOpen = false }
                    }
            }

            VStack(spacing: 0) {
                // Trigger
                trigger

                // Dropdown
                if isOpen {
                    contentView
                        .transition(.opacity.combined(with: .scale(scale: 0.95, anchor: .top)))
                }
            }
        }
        .animation(.easeInOut(duration: 0.15), value: isOpen)
    }

    @ViewBuilder
    private var trigger: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.15)) { isOpen.toggle() }
        } label: {
            HStack(spacing: 8) {
                Text(String(describing: selection))
                    .font(.system(size: 14))
                    .lineLimit(1)
                Spacer(minLength: 4)
                Image(systemName: "chevron.down")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(token.mutedForeground)
            }
            .frame(height: 36)
            .padding(.horizontal, 12)
            .background(token.card)
            .foregroundStyle(token.foreground)
            .clipShape(RoundedRectangle(cornerRadius: token.radius))
            .overlay(
                RoundedRectangle(cornerRadius: token.radius)
                    .strokeBorder(token.border, lineWidth: 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.borderless)
        .zIndex(1)
    }

    @ViewBuilder
    private var contentView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                content()
            }
        }
        .frame(maxHeight: 280)
        .frame(minWidth: 180)
        .background(token.card)
        .clipShape(RoundedRectangle(cornerRadius: token.radius * 1.5))
        .overlay(
            RoundedRectangle(cornerRadius: token.radius * 1.5)
                .strokeBorder(token.border, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.15), radius: 16, y: 8)
        .environment(\.selectAction, SelectAction { value in
            if let v = value as? Value {
                selection = v
                isOpen = false
            }
        })
        .environment(\.selectValue, AnyHashable(selection))
        .zIndex(2)
    }
}

// MARK: - SelectItem

/// A selectable option inside a `Select` dropdown.
public struct SelectItem<Value: Hashable & Sendable>: View {
    @Environment(\.shadcnToken) private var token
    @Environment(\.selectAction) private var action
    @Environment(\.selectValue) private var currentValue

    let label: String
    let value: Value

    public init(_ label: String, value: Value) {
        self.label = label
        self.value = value
    }

    private var isSelected: Bool {
        currentValue == AnyHashable(value)
    }

    public var body: some View {
        Button {
            action.handler(value)
        } label: {
            HStack(spacing: 10) {
                Text(label)
                    .font(.system(size: 14))
                    .foregroundStyle(token.foreground)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(token.primary)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(isSelected ? token.muted : Color.clear)
            .contentShape(Rectangle())
        }
        .buttonStyle(.borderless)
    }
}

// MARK: - SelectGroup / SelectLabel / SelectSeparator

/// Groups select items together (no visual separator).
public struct SelectGroup<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View { VStack(alignment: .leading, spacing: 0) { content() } }
}

/// A section heading inside a select dropdown.
public struct SelectLabel: View {
    @Environment(\.shadcnToken) private var token
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(token.mutedForeground)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
    }
}

/// A horizontal divider inside a select dropdown.
public struct SelectSeparator: View {
    @Environment(\.shadcnToken) private var token
    public init() {}
    public var body: some View {
        Rectangle().fill(token.border).frame(height: 1)
    }
}
