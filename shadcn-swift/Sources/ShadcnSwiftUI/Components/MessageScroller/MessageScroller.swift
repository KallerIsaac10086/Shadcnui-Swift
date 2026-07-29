import SwiftUI

// MARK: - MessageScroller

/// An auto-scrolling chat message list. Corresponds to `<MessageScroller>` in shadcn/ui.
///
/// Auto-scrolls to bottom when new messages arrive, pauses when user scrolls up.
///
/// Usage:
/// ```swift
/// MessageScroller {
///     ForEach(messages) { msg in
///         Message(align: msg.isMe ? .end : .start) { ... }
///     }
/// }
/// ```
public struct MessageScroller<Content: View>: View {
    @ViewBuilder let content: () -> Content
    @State private var autoScroll = true

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 12) {
                    content()
                }
                .padding(12)
            }
            .onChange(of: autoScroll) { _, newValue in
                if newValue {
                    withAnimation { proxy.scrollTo("bottom", anchor: .bottom) }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                if !autoScroll {
                    Button {
                        autoScroll = true
                    } label: {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(.primary)
                            .background(Circle().fill(.regularMaterial))
                    }
                    .padding(12)
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .id("bottom")
        }
    }
}
