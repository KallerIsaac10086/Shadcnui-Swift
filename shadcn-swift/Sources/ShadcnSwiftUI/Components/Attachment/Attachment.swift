import SwiftUI

// MARK: - Attachment

/// A file attachment pill with icon, metadata, and remove action.
///
/// Corresponds to `<Attachment>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// Attachment {
///     AttachmentMedia { Image(systemName: "doc") }
///     AttachmentContent {
///         AttachmentTitle("report.pdf")
///         AttachmentDescription("PDF · 2.4 MB")
///     }
///     AttachmentActions {
///         AttachmentAction { /* remove */ }
///     }
/// }
/// ```
public struct Attachment<Content: View>: View {
    @Environment(\.shadcnToken) private var token
    let size: AttachmentSize
    @ViewBuilder let content: () -> Content

    public init(size: AttachmentSize = .default, @ViewBuilder content: @escaping () -> Content) {
        self.size = size; self.content = content
    }

    public var body: some View {
        HStack(spacing: 12) {
            content()
        }
        .padding(12)
        .background(token.card)
        .clipShape(RoundedRectangle(cornerRadius: token.radius))
        .overlay(RoundedRectangle(cornerRadius: token.radius).strokeBorder(token.border, lineWidth: 1))
    }
}

public enum AttachmentSize: Sendable { case xs, sm, `default` }

public struct AttachmentMedia<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View { content() }
}

public struct AttachmentContent<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View {
        VStack(alignment: .leading, spacing: 2) { content() }.frame(maxWidth: .infinity, alignment: .leading)
    }
}

public struct AttachmentTitle: View {
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View { Text(text).font(.system(size: 14, weight: .medium)).lineLimit(1) }
}

public struct AttachmentDescription: View {
    @Environment(\.shadcnToken) private var token
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View { Text(text).font(.system(size: 12)).foregroundColor(token.mutedForeground) }
}

public struct AttachmentActions<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View { HStack(spacing: 4) { content() } }
}

public struct AttachmentAction: View {
    @Environment(\.shadcnToken) private var token
    let action: () -> Void
    public init(action: @escaping () -> Void = {}) { self.action = action }
    public var body: some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(token.mutedForeground)
        }
        .buttonStyle(.borderless)
        .frame(width: 24, height: 24)
    }
}
