import SwiftUI

// MARK: - Bubble

/// A chat bubble. Corresponds to `<Bubble>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// Bubble(align: .start) { BubbleContent("Hello!") }
/// Bubble(align: .end)   { BubbleContent("Hey there!") }
/// ```
public struct Bubble<Content: View>: View {
    @Environment(\.shadcnToken) private var token

    public enum Align: Sendable { case start, end }
    let align: Align
    @ViewBuilder let content: () -> Content

    public init(align: Align = .start, @ViewBuilder content: @escaping () -> Content) {
        self.align = align; self.content = content
    }

    public var body: some View {
        HStack {
            if align == .end { Spacer() }
            content()
            if align == .start { Spacer() }
        }
    }
}

// MARK: - BubbleContent

public struct BubbleContent<Content: View>: View {
    @Environment(\.shadcnToken) private var token

    @ViewBuilder let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public init(_ text: String) where Content == Text { self.content = { Text(text) } }

    public var body: some View {
        content()
            .font(.system(size: 14))
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(token.muted)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .frame(maxWidth: 280, alignment: .leading)
    }
}
