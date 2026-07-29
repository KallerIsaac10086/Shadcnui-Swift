import SwiftUI

// MARK: - HoverCard Modifier

/// A card that appears on hover (macOS) or long-press (iOS).
///
/// Corresponds to `<HoverCard>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// Text("Hover me")
///     .hoverCard {
///         HoverCardContent {
///             Text("Details here")
///         }
///     }
/// ```
public struct HoverCardModifier<CardContent: View>: ViewModifier {
    @Environment(\.shadcnToken) private var token

    @ViewBuilder let card: () -> CardContent
    @State private var isVisible = false

    public func body(content: Content) -> some View {
        content
        #if os(macOS)
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.15)) { isVisible = hovering }
            }
        #endif
            .onLongPressGesture(minimumDuration: 0.5) {
                withAnimation(.easeInOut(duration: 0.15)) { isVisible = true }
            }
            .overlay(alignment: .bottom) {
                if isVisible {
                    card()
                        .fixedSize(horizontal: true, vertical: false)
                        .offset(y: 8)
                        .transition(.scale(scale: 0.95).combined(with: .opacity))
                }
            }
            .animation(.easeInOut(duration: 0.15), value: isVisible)
    }
}

public extension View {
    func hoverCard<Content: View>(
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(HoverCardModifier(card: content))
    }
}

// MARK: - HoverCardContent

public struct HoverCardContent<Content: View>: View {
    @Environment(\.shadcnToken) private var token

    @ViewBuilder let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            content()
        }
        .frame(minWidth: 200)
        .padding(16)
        .background(token.popover)
        .clipShape(RoundedRectangle(cornerRadius: token.radius))
        .overlay(
            RoundedRectangle(cornerRadius: token.radius)
                .strokeBorder(token.border, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 8, y: 2)
    }
}
