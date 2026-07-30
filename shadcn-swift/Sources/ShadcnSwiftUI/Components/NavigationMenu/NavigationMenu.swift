import SwiftUI

// MARK: - NavigationMenu

/// A horizontal navigation bar with dropdowns. Corresponds to `<NavigationMenu>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// NavigationMenu {
///     NavigationMenuList {
///         NavigationMenuItem("Home") { ... }
///         NavigationMenuItem("Products") { ... }
///         NavigationMenuItem("About") { ... }
///     }
/// }
/// ```
public struct NavigationMenu<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View { content() }
}

public struct NavigationMenuList<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View { HStack(spacing: 4) { content() } }
}

public struct NavigationMenuItem: View {
    @Environment(\.shadcnToken) private var token
    let text: String
    let action: () -> Void

    public init(_ text: String, action: @escaping () -> Void) {
        self.text = text; self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .foregroundColor(token.foreground)
                .clipShape(RoundedRectangle(cornerRadius: token.radius))
        }
        .buttonStyle(.borderless)
    }
}

public struct NavigationMenuLink: View {
    @Environment(\.shadcnToken) private var token
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text).font(.system(size: 14)).foregroundColor(token.foreground)
    }
}
