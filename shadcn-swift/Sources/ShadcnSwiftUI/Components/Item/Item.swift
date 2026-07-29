import SwiftUI

// MARK: - Item

/// A list row with media, content, and actions. Corresponds to `<Item>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// Item {
///     ItemMedia { Image(systemName: "person.circle") }
///     ItemContent {
///         ItemTitle("John Doe")
///         ItemDescription("john@example.com")
///     }
///     ItemActions {
///         Button("Edit") { }.shadcnButton(variant: .ghost, size: .sm)
///     }
/// }
/// ```
public struct Item<Content: View>: View {
    @Environment(\.shadcnToken) private var token
    let size: ItemSize
    @ViewBuilder let content: () -> Content

    public init(size: ItemSize = .default, @ViewBuilder content: @escaping () -> Content) {
        self.size = size; self.content = content
    }

    public var body: some View {
        HStack(spacing: 12) {
            content()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, vPad)
        .frame(minHeight: minHeight)
        .background(token.card)
        .clipShape(RoundedRectangle(cornerRadius: token.radius))
        .overlay(RoundedRectangle(cornerRadius: token.radius).strokeBorder(token.border, lineWidth: 1))
    }

    private var vPad: CGFloat { size == .xs ? 6 : size == .sm ? 8 : 10 }
    private var minHeight: CGFloat { size == .xs ? 36 : size == .sm ? 40 : 48 }
}

public enum ItemSize: Sendable { case xs, sm, `default` }

public struct ItemMedia<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View { content() }
}

public struct ItemContent<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View {
        VStack(alignment: .leading, spacing: 2) { content() }.frame(maxWidth: .infinity, alignment: .leading)
    }
}

public struct ItemTitle: View {
    @Environment(\.shadcnToken) private var token
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text).font(.system(size: 14, weight: .medium)).foregroundColor(token.foreground)
    }
}

public struct ItemDescription: View {
    @Environment(\.shadcnToken) private var token
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text).font(.system(size: 13)).foregroundColor(token.mutedForeground)
    }
}

public struct ItemActions<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View { HStack(spacing: 4) { content() } }
}
