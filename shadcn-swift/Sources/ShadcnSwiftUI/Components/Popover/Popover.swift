import SwiftUI

// MARK: - Popover Modifier

/// A popover that appears next to its anchor. Corresponds to `<Popover>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// @State var showPopover = false
/// Button("Toggle") { showPopover.toggle() }
///     .popover(isPresented: $showPopover) {
///         PopoverContent {
///             PopoverTitle("Title")
///             PopoverDescription("Description")
///         }
///     }
/// ```
public struct PopoverModifier<PopoverContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    @ViewBuilder let popover: () -> PopoverContent

    public func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if isPresented {
                    popover()
                        .transition(.scale(scale: 0.95).combined(with: .opacity))
                }
            }
            .animation(.easeInOut(duration: 0.15), value: isPresented)
    }
}

public extension View {
    func popover<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(PopoverModifier(isPresented: isPresented, popover: content))
    }
}

// MARK: - PopoverContent

public struct PopoverContent<Content: View>: View {
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

// MARK: - Sub-components

public struct PopoverTitle: View {
    @Environment(\.shadcnToken) private var token
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text).font(.system(size: 14, weight: .medium)).foregroundColor(token.foreground)
    }
}

public struct PopoverDescription: View {
    @Environment(\.shadcnToken) private var token
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text).font(.system(size: 13)).foregroundColor(token.mutedForeground)
    }
}
