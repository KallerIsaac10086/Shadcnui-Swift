import SwiftUI

// MARK: - DropdownMenu

/// A dropdown menu with items, separators, and submenus. Corresponds to `<DropdownMenu>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// DropdownMenu {
///     DropdownMenuTrigger { Text("Open Menu") }
///     DropdownMenuContent {
///         DropdownMenuLabel("Account")
///         DropdownMenuItem("Profile") { ... }
///         DropdownMenuItem("Settings") { ... }
///         DropdownMenuSeparator()
///         DropdownMenuItem("Logout", variant: .destructive) { ... }
///     }
/// }
/// ```
public struct DropdownMenu<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View {
        Menu { content() } label: { EmptyView() }
    }
}

// MARK: - DropdownMenuTrigger

public struct DropdownMenuTrigger<Label: View>: View {
    @ViewBuilder let label: () -> Label
    public init(@ViewBuilder label: @escaping () -> Label) { self.label = label }
    public var body: some View {
        label()
    }
}

// MARK: - DropdownMenuContent

public struct DropdownMenuContent<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View {
        content()
    }
}

// MARK: - DropdownMenuLabel

public struct DropdownMenuLabel: View {
    @Environment(\.shadcnToken) private var token
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text).font(.system(size: 12, weight: .semibold)).foregroundColor(token.mutedForeground).padding(.horizontal, 8).padding(.vertical, 4)
    }
}

// MARK: - DropdownMenuItem

public struct DropdownMenuItem: View {
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

// MARK: - DropdownMenuSeparator

public struct DropdownMenuSeparator: View {
    public init() {}
    public var body: some View { Divider() }
}

// MARK: - DropdownMenuShortcut

public struct DropdownMenuShortcut: View {
    @Environment(\.shadcnToken) private var token
    let key: String
    public init(_ key: String) { self.key = key }
    public var body: some View {
        Text(key).font(.system(size: 12, design: .monospaced)).foregroundColor(token.mutedForeground)
    }
}
