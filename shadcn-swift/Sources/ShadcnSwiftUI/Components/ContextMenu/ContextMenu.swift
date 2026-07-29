import SwiftUI

// MARK: - ContextMenu Modifier

/// A context menu triggered by long press (iOS) or right-click (macOS). Corresponds to `<ContextMenu>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// Text("Right-click me")
///     .shadcnContextMenu {
///         ContextMenuItem("Copy") { ... }
///         ContextMenuItem("Share") { ... }
///         ContextMenuSeparator()
///         ContextMenuItem("Delete", variant: .destructive) { ... }
///     }
/// ```
public struct ShadcnContextMenuModifier<MenuContent: View>: ViewModifier {
    @ViewBuilder let menu: () -> MenuContent

    public func body(content: Content) -> some View {
        content.contextMenu { menu() }
    }
}

public extension View {
    func shadcnContextMenu<MenuContent: View>(
        @ViewBuilder menu: @escaping () -> MenuContent
    ) -> some View {
        modifier(ShadcnContextMenuModifier(menu: menu))
    }
}

// MARK: - ContextMenuItem

public struct ContextMenuItem: View {
    public enum Variant: Sendable { case `default`, destructive }
    let text: String
    let variant: Variant
    let action: () -> Void

    public init(_ text: String, variant: Variant = .default, action: @escaping () -> Void) {
        self.text = text; self.variant = variant; self.action = action
    }

    public var body: some View {
        Button(role: variant == .destructive ? .destructive : nil, action: action) {
            Text(text)
        }
    }
}

// MARK: - ContextMenuSeparator

public struct ContextMenuSeparator: View { public init() {} public var body: some View { Divider() } }
