import SwiftUI

// MARK: - ContextMenu Modifier

/// A shadcn‑styled context menu triggered by click.  Uses Portal rendering
/// for correct z‑index and custom styling (not native macOS menu).
///
/// Usage:
/// ```swift
/// HStack { ... }
///     .shadcnContextMenu {
///         ContextMenuItem("Copy") { ... }
///         ContextMenuSeparator()
///         ContextMenuItem("Delete", variant: .destructive) { ... }
///     }
/// ```
public struct ContextMenuModifier<Menu: View>: ViewModifier {
    @StateObject private var coordinator = DropdownCoordinator()
    @State private var menuID = UUID()
    @ViewBuilder let menu: () -> Menu

    public init(@ViewBuilder menu: @escaping () -> Menu) {
        self.menu = menu
    }

    public func body(content: Content) -> some View {
        content
            .overlay {
                Color.clear
                    .contentShape(Rectangle())
                    .anchorPreference(key: PortalAnchorKey.self, value: .bounds) {
                        coordinator.openID == menuID ? [menuID: $0] : [:]
                    }
            }
            .onTapGesture {
                withAnimation(.easeOut(duration: 0.15)) {
                    coordinator.openID = (coordinator.openID == menuID) ? nil : menuID
                }
            }
            .onChange(of: coordinator.openID) { _, newValue in
                guard newValue == menuID else {
                    PortalHost.shared.hide(id: menuID)
                    return
                }
                let panel = AnyView(
                    DropdownPanel { menu() }
                        .environmentObject(coordinator)
                )
                PortalHost.shared.show(id: menuID, content: panel, anchor: .topLeading)
            }
            .onDisappear { PortalHost.shared.hide(id: menuID) }
    }
}

private struct DropdownPanel<Content: View>: View {
    @Environment(\.shadcnToken) private var token
    @ViewBuilder let content: () -> Content
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            content()
        }
        .frame(minWidth: 192)
        .padding(6)
        .background(token.popover)
        .clipShape(RoundedRectangle(cornerRadius: token.radius))
        .overlay(RoundedRectangle(cornerRadius: token.radius).strokeBorder(token.border, lineWidth: 1))
        .shadow(color: .black.opacity(0.12), radius: 10, y: 4)
    }
}

public extension View {
    func shadcnContextMenu<Menu: View>(
        @ViewBuilder menu: @escaping () -> Menu
    ) -> some View {
        modifier(ContextMenuModifier(menu: menu))
    }
}

// MARK: - ContextMenuItem

public struct ContextMenuItem: View {
    public enum Variant: Sendable { case `default`, destructive }
    @Environment(\.shadcnToken) private var token
    @EnvironmentObject private var coordinator: DropdownCoordinator
    @State private var hovered = false
    let text: String; let variant: Variant; let action: () -> Void

    public init(_ text: String, variant: Variant = .default, action: @escaping () -> Void) {
        self.text = text; self.variant = variant; self.action = action
    }

    public var body: some View {
        Button {
            action()
            withAnimation(.easeOut(duration: 0.15)) { coordinator.openID = nil }
        } label: {
            Text(text)
                .font(.system(size: 13))
                .foregroundColor(variant == .destructive ? token.destructive : (hovered ? token.accentForeground : token.foreground))
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

// MARK: - ContextMenuSeparator

public struct ContextMenuSeparator: View {
    @Environment(\.shadcnToken) private var token
    public init() {}
    public var body: some View {
        Rectangle().fill(token.border).frame(height: 1)
            .padding(.horizontal, -4).padding(.vertical, 4)
    }
}
