import SwiftUI

// MARK: - Direction

/// Layout direction for RTL/LTR support. Corresponds to `Direction` in shadcn/ui.
public enum Direction: String, CaseIterable, Sendable {
    case ltr
    case rtl
}

// MARK: - DirectionProvider

/// Wraps content and injects layout direction.
///
/// Usage:
/// ```swift
/// DirectionProvider(direction: .rtl) {
///     Text("مرحبا")
/// }
/// ```
public struct DirectionProvider<Content: View>: View {
    let direction: Direction
    @ViewBuilder let content: () -> Content

    public init(
        direction: Direction,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.direction = direction
        self.content = content
    }

    public var body: some View {
        content()
            .environment(\.layoutDirection, direction == .rtl ? .rightToLeft : .leftToRight)
    }
}
