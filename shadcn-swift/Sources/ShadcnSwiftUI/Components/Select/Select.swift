import SwiftUI

// MARK: - Coordinator

private final class SelectCoordinator: ObservableObject {
    @Published var openID: UUID?
}

// MARK: - Environment

private struct SelectMenuIDKey: EnvironmentKey {
    static let defaultValue: UUID = .init()
}

private struct SelectActionKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue: (AnyHashable) -> Void = { _ in }
}

extension EnvironmentValues {
    fileprivate var selectMenuID: UUID {
        get { self[SelectMenuIDKey.self] }
        set { self[SelectMenuIDKey.self] = newValue }
    }
    fileprivate var selectAction: (AnyHashable) -> Void {
        get { self[SelectActionKey.self] }
        set { self[SelectActionKey.self] = newValue }
    }
}

// MARK: - Select (Root)

/// A custom dropdown select.  Corresponds to `<Select>` in shadcn/ui.
///
/// **TSX‑style** (trigger + content as children):
/// ```swift
/// Select(selection: $selection) {
///     SelectTrigger {
///         SelectValue(placeholder: "Theme")
///     }
///     SelectContent {
///         SelectGroup {
///             SelectLabel("Options")
///             SelectItem("Light", value: "light")
///         }
///     }
/// }
/// ```
///
/// **Legacy inline** (kept for backward compat):
/// ```swift
/// Select("Theme", selection: $selection) {
///     SelectItem("Light", value: "light")
/// }
/// ```
public struct Select<Value: Hashable & Sendable, Content: View>: View {
    @StateObject private var coordinator = SelectCoordinator()
    @State private var menuID = UUID()

    @Binding var selection: Value
    let placeholder: String
    @ViewBuilder let content: () -> Content

    public init(
        _ placeholder: String = "",
        selection: Binding<Value>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._selection = selection
        self.placeholder = placeholder
        self.content = content
    }

    public var body: some View {
        ZStack(alignment: .topLeading) {
            content()
        }
        .environment(\.selectMenuID, menuID)
        .environment(\.selectAction) { value in
            if let v = value as? Value {
                selection = v
                coordinator.openID = nil
            }
        }
        .environmentObject(coordinator)
    }
}

// MARK: - SelectTrigger

/// The clickable trigger button.  Sets `PortalAnchorKey` for portal positioning.
public struct SelectTrigger<Content: View>: View {
    @Environment(\.shadcnToken) private var token
    @EnvironmentObject private var coordinator: SelectCoordinator
    @Environment(\.selectMenuID) private var menuID
    @ViewBuilder let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }

    private var isOpen: Bool { coordinator.openID == menuID }

    public var body: some View {
        Button {
            withAnimation(.easeOut(duration: 0.15)) {
                coordinator.openID = isOpen ? nil : menuID
            }
        } label: {
            HStack(spacing: 8) {
                content()
                Spacer(minLength: 4)
                Image(systemName: "chevron.down")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(token.mutedForeground)
                    .rotationEffect(.degrees(isOpen ? 180 : 0))
            }
            .frame(height: 36)
            .padding(.horizontal, 12)
            .background(token.background)
            .clipShape(RoundedRectangle(cornerRadius: token.radius))
            .overlay(
                RoundedRectangle(cornerRadius: token.radius)
                    .strokeBorder(token.input, lineWidth: 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.borderless)
        .anchorPreference(key: PortalAnchorKey.self, value: .bounds) { [menuID: $0] }
    }
}

// MARK: - SelectValue

/// Displays the placeholder or selected value inside `SelectTrigger`.
public struct SelectValue: View {
    @Environment(\.shadcnToken) private var token

    let placeholder: String
    let selection: String?

    public init(placeholder: String = "", selection: String? = nil) {
        self.placeholder = placeholder
        self.selection = selection
    }

    public var body: some View {
        Text(selection ?? placeholder)
            .font(.system(size: 14))
            .foregroundColor(selection != nil ? token.foreground : token.mutedForeground)
            .lineLimit(1)
    }
}

// MARK: - SelectContent

/// Wraps the dropdown content.  Registers the panel in `PortalHost`.
public struct SelectContent<Content: View>: View {
    @Environment(\.shadcnToken) private var token
    @EnvironmentObject private var coordinator: SelectCoordinator
    @Environment(\.selectMenuID) private var menuID
    @ViewBuilder let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }

    public var body: some View {
        Color.clear
            .onChange(of: coordinator.openID) { _, newValue in
                guard newValue == menuID else {
                    PortalHost.shared.hide(id: menuID)
                    return
                }
                let panel = AnyView(
                    ScrollView {
                        VStack(spacing: 0) { content() }
                    }
                    .frame(maxHeight: 280)
                    .frame(minWidth: 180)
                    .background(token.popover)
                    .clipShape(RoundedRectangle(cornerRadius: token.radius))
                    .overlay(
                        RoundedRectangle(cornerRadius: token.radius)
                            .strokeBorder(token.border, lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.12), radius: 10, y: 4)
                )
                PortalHost.shared.show(id: menuID, content: panel, anchor: .topLeading)
            }
    }
}

// MARK: - SelectItem

public struct SelectItem<Value: Hashable & Sendable>: View {
    @Environment(\.shadcnToken) private var token
    @Environment(\.selectAction) private var onSelect
    @State private var hovered = false

    let label: String
    let value: Value
    let isSelected: Bool

    public init(_ label: String, value: Value, isSelected: Bool = false) {
        self.label = label
        self.value = value
        self.isSelected = isSelected
    }

    public var body: some View {
        Button {
            onSelect(value)
        } label: {
            HStack(spacing: 10) {
                Text(label)
                    .font(.system(size: 14))
                    .foregroundColor(hovered ? token.accentForeground : token.foreground)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(token.primary)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(hovered ? token.accent : Color.clear)
            .contentShape(Rectangle())
        }
        .buttonStyle(.borderless)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .onHover { hovered = $0 }
    }
}

// MARK: - SelectGroup / SelectLabel / SelectSeparator

public struct SelectGroup<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) { content() }
    }
}

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

public struct SelectSeparator: View {
    @Environment(\.shadcnToken) private var token
    public init() {}
    public var body: some View {
        Rectangle().fill(token.border).frame(height: 1)
            .padding(.horizontal, -4).padding(.vertical, 4)
    }
}
