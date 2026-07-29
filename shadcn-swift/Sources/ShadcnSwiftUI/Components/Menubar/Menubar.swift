import SwiftUI

// MARK: - Menubar

/// A horizontal menubar for desktop apps. Corresponds to `<Menubar>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// Menubar {
///     MenubarMenu("File") {
///         MenubarItem("New") { ... }
///         MenubarItem("Open") { ... }
///         MenubarSeparator()
///         MenubarItem("Quit", variant: .destructive) { ... }
///     }
///     MenubarMenu("Edit") {
///         MenubarItem("Copy") { ... }
///     }
/// }
/// ```
public struct Menubar<Content: View>: View {
    @Environment(\.shadcnToken) private var token
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View {
        HStack(spacing: 2) { content() }
            .padding(4)
            .background(token.card)
            .overlay(RoundedRectangle(cornerRadius: token.radius).strokeBorder(token.border, lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: token.radius))
    }
}

public struct MenubarMenu<Content: View>: View {
    @Environment(\.shadcnToken) private var token
    let label: String
    @ViewBuilder let content: () -> Content
    public init(_ label: String, @ViewBuilder content: @escaping () -> Content) {
        self.label = label; self.content = content
    }
    public var body: some View {
        Menu {
            content()
        } label: {
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .foregroundColor(token.foreground)
                .clipShape(RoundedRectangle(cornerRadius: token.radius - 2))
        }
    }
}

public struct MenubarItem: View {
    public enum Variant: Sendable { case `default`, destructive }
    let text: String
    let variant: Variant
    let action: () -> Void
    public init(_ text: String, variant: Variant = .default, action: @escaping () -> Void) {
        self.text = text; self.variant = variant; self.action = action
    }
    public var body: some View {
        Button(role: variant == .destructive ? .destructive : nil, action: action) { Text(text) }
    }
}

public struct MenubarSeparator: View { public init() {} public var body: some View { Divider() } }
