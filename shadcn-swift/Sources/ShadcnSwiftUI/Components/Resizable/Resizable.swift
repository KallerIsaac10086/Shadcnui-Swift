import SwiftUI

// MARK: - ResizablePanelGroup

/// A resizable panel group (split view). Corresponds to `<Resizable>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// ResizablePanelGroup(orientation: .horizontal) {
///     ResizablePanel(minSize: 150) { SidebarView() }
///     ResizableHandle()
///     ResizablePanel { MainView() }
/// }
/// ```
public struct ResizablePanelGroup<Content: View>: View {
    public enum Orientation: Sendable { case horizontal, vertical }

    let orientation: Orientation
    @ViewBuilder let content: () -> Content

    public init(orientation: Orientation = .horizontal, @ViewBuilder content: @escaping () -> Content) {
        self.orientation = orientation
        self.content = content
    }

    public var body: some View {
        Group {
            if orientation == .horizontal {
                #if os(macOS)
                HSplitView { content().frame(minWidth: 100) }
                #else
                HStack(spacing: 0) { content() }
                #endif
            } else {
                #if os(macOS)
                VSplitView { content().frame(minHeight: 100) }
                #else
                VStack(spacing: 0) { content() }
                #endif
            }
        }
    }
}

// MARK: - ResizablePanel

public struct ResizablePanel<Content: View>: View {
    let minSize: CGFloat?
    @ViewBuilder let content: () -> Content

    public init(minSize: CGFloat? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.minSize = minSize
        self.content = content
    }

    public var body: some View {
        content()
            .frame(
                minWidth: minSize,
                minHeight: minSize
            )
    }
}

// MARK: - ResizableHandle

public struct ResizableHandle: View {
    @Environment(\.shadcnToken) private var token

    public init() {}

    public var body: some View {
        Rectangle()
            .fill(token.border)
            .frame(width: 4, height: 4)
            .frame(width: 8, height: 24)
            .background(token.muted)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}
