import SwiftUI

// MARK: - Message

/// A chat message row with avatar, header, and footer. Corresponds to `<Message>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// Message(align: .start) {
///     MessageAvatar { Avatar(size: .sm) { AvatarFallback(initials: "JD") } }
///     MessageContent {
///         MessageHeader {
///             Text("John").fontWeight(.medium)
///             Text("2 min ago").font(.caption).foregroundStyle(.secondary)
///         }
///         Bubble(align: .start) { BubbleContent("Hello!") }
///     }
/// }
/// ```
public struct Message<Content: View>: View {
    public enum Align: Sendable { case start, end }
    let align: Align
    @ViewBuilder let content: () -> Content

    public init(align: Align = .start, @ViewBuilder content: @escaping () -> Content) {
        self.align = align; self.content = content
    }

    public var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if align == .end { Spacer() }
            content()
            if align == .start { Spacer() }
        }
    }
}

public struct MessageAvatar<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View { content() }
}

public struct MessageContent<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View { VStack(alignment: .leading, spacing: 4) { content() } }
}

public struct MessageHeader<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View { HStack(spacing: 8) { content() } }
}

public struct MessageFooter<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View { HStack(spacing: 8) { content() } }
}
