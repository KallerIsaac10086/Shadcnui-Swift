import SwiftUI

// MARK: - Coordinator

public final class DropdownCoordinator: ObservableObject {
    @Published var openID: UUID?
}

// MARK: - Environment

private struct DropdownMenuIDKey: EnvironmentKey {
    static let defaultValue: UUID = .init()
}
extension EnvironmentValues {
    fileprivate var dropdownMenuID: UUID {
        get { self[DropdownMenuIDKey.self] }
        set { self[DropdownMenuIDKey.self] = newValue }
    }
}

// MARK: - DropdownMenu

public struct DropdownMenu<Content: View>: View {
    @StateObject private var coordinator = DropdownCoordinator()
    @State private var menuID = UUID()
    @ViewBuilder let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }

    public var body: some View {
        ZStack(alignment: .topLeading) {
            content()
        }
        .environmentObject(coordinator)
        .environment(\.dropdownMenuID, menuID)
    }
}

// MARK: - DropdownMenuTrigger

public struct DropdownMenuTrigger<Label: View>: View {
    @Environment(\.shadcnToken) private var token
    @EnvironmentObject private var coordinator: DropdownCoordinator
    @Environment(\.dropdownMenuID) private var menuID
    @ViewBuilder let label: () -> Label

    public init(@ViewBuilder label: @escaping () -> Label) { self.label = label }
    private var isOpen: Bool { coordinator.openID == menuID }

    public var body: some View {
        Button {
            withAnimation(.easeOut(duration: 0.15)) {
                coordinator.openID = isOpen ? nil : menuID
            }
        } label: {
            label()
        }
        .buttonStyle(.borderless)
        .anchorPreference(key: PortalAnchorKey.self, value: .bounds) { [menuID: $0] }
    }
}

// MARK: - DropdownMenuContent

public struct DropdownMenuContent<Content: View>: View {
    @Environment(\.shadcnToken) private var token
    @EnvironmentObject private var coordinator: DropdownCoordinator
    @Environment(\.dropdownMenuID) private var menuID
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
                    VStack(alignment: .leading, spacing: 2) {
                        content()
                    }
                    .frame(minWidth: 192)
                    .padding(6)
                    .background(token.popover)
                    .clipShape(RoundedRectangle(cornerRadius: token.radius))
                    .overlay(RoundedRectangle(cornerRadius: token.radius).strokeBorder(token.border, lineWidth: 1))
                    .shadow(color: .black.opacity(0.12), radius: 10, y: 4)
                )
                PortalHost.shared.show(id: menuID, content: panel, anchor: .topLeading)
            }
    }
}

// MARK: - DropdownMenuItem

public struct DropdownMenuItem: View {
    public enum Variant: Sendable { case `default`, destructive }

    @Environment(\.shadcnToken) private var token
    @EnvironmentObject private var coordinator: DropdownCoordinator
    @State private var hovered = false

    let text: String
    let variant: Variant
    let shortcut: String?
    let action: () -> Void

    public init(_ text: String, variant: Variant = .default, shortcut: String? = nil, action: @escaping () -> Void) {
        self.text = text; self.variant = variant; self.shortcut = shortcut; self.action = action
    }

    public var body: some View {
        Button {
            action()
            withAnimation(.easeOut(duration: 0.15)) { coordinator.openID = nil }
        } label: {
            HStack(spacing: 8) {
                Text(text)
                    .font(.system(size: 13))
                    .foregroundColor(variant == .destructive ? token.destructive : (hovered ? token.accentForeground : token.foreground))
                if let s = shortcut {
                    Spacer(minLength: 24)
                    Text(s).font(.system(size: 12, design: .monospaced)).foregroundColor(token.mutedForeground)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 8).padding(.vertical, 6)
            .background(hovered ? (variant == .destructive ? token.destructive.opacity(0.12) : token.accent) : Color.clear)
            .contentShape(Rectangle())
        }
        .buttonStyle(.borderless)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .onHover { hovered = $0 }
    }
}

// MARK: - Misc

public struct DropdownMenuLabel: View {
    @Environment(\.shadcnToken) private var token
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text).font(.system(size: 12, weight: .semibold)).foregroundColor(token.mutedForeground)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 8).padding(.vertical, 4)
    }
}

public struct DropdownMenuSeparator: View {
    @Environment(\.shadcnToken) private var token
    public init() {}
    public var body: some View {
        Rectangle().fill(token.border).frame(height: 1)
            .padding(.horizontal, -4).padding(.vertical, 4)
    }
}

public struct DropdownMenuShortcut: View {
    @Environment(\.shadcnToken) private var token
    let key: String
    public init(_ key: String) { self.key = key }
    public var body: some View {
        Text(key).font(.system(size: 12, design: .monospaced)).foregroundColor(token.mutedForeground)
    }
}
