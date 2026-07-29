import SwiftUI

// MARK: - Empty

/// Empty state placeholder. Corresponds to `<Empty>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// Empty {
///     EmptyHeader {
///         EmptyMedia(icon: Image(systemName: "tray"))
///         EmptyTitle("No items")
///         EmptyDescription("Get started by adding your first item.")
///     }
///     EmptyContent {
///         Button("Add Item") { }.shadcnButton()
///     }
/// }
/// ```
public struct Empty<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View {
        VStack(spacing: 0) { content() }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

public struct EmptyHeader<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View {
        VStack(spacing: 12) { content() }.padding(.bottom, 24)
    }
}

public struct EmptyMedia: View {
    @Environment(\.shadcnToken) private var token
    let icon: Image?
    public init(icon: Image? = nil) { self.icon = icon }
    public var body: some View {
        if let icon {
            icon
                .font(.system(size: 40))
                .foregroundColor(token.mutedForeground)
                .frame(width: 64, height: 64)
                .background(token.muted)
                .clipShape(Circle())
        }
    }
}

public struct EmptyTitle: View {
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text).font(.system(size: 18, weight: .semibold)).multilineTextAlignment(.center)
    }
}

public struct EmptyDescription: View {
    @Environment(\.shadcnToken) private var token
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text).font(.system(size: 14)).foregroundColor(token.mutedForeground).multilineTextAlignment(.center)
    }
}

public struct EmptyContent<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View {
        HStack(spacing: 8) { content() }
    }
}
