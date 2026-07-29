import SwiftUI

// MARK: - ButtonGroup

/// A group of buttons with merged borders. Corresponds to `<ButtonGroup>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// ButtonGroup {
///     Button("One") { }.shadcnButton(variant: .outline)
///     Button("Two") { }.shadcnButton(variant: .outline)
/// }
/// ButtonGroup(orientation: .vertical) {
///     Button("Top") { }.shadcnButton(variant: .outline)
///     Button("Bottom") { }.shadcnButton(variant: .outline)
/// }
/// ```
public struct ButtonGroup<Content: View>: View {
    public enum Orientation: Sendable {
        case horizontal
        case vertical
    }

    @Environment(\.shadcnToken) private var token

    let orientation: Orientation
    @ViewBuilder let content: () -> Content

    public init(
        orientation: Orientation = .horizontal,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.orientation = orientation
        self.content = content
    }

    public var body: some View {
        Group {
            if orientation == .horizontal {
                HStack(spacing: 0) { content() }
            } else {
                VStack(spacing: 0) { content() }
            }
        }
    }
}
