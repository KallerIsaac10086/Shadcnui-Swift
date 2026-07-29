import SwiftUI

// MARK: - Separator

/// Horizontal or vertical divider. Corresponds to `<Separator>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// Separator()                          // horizontal (default)
/// Separator(orientation: .vertical)    // vertical
/// ```
public struct Separator: View {
    @Environment(\.shadcnToken) private var token

    let orientation: Orientation
    let decorative: Bool

    public enum Orientation: Sendable {
        case horizontal
        case vertical
    }

    public init(orientation: Orientation = .horizontal, decorative: Bool = true) {
        self.orientation = orientation
        self.decorative = decorative
    }

    public var body: some View {
        Rectangle()
            .fill(token.border)
            .frame(
                width: orientation == .vertical ? 1 : nil,
                height: orientation == .horizontal ? 1 : nil
            )
            .frame(
                maxWidth: orientation == .horizontal ? .infinity : nil,
                maxHeight: orientation == .vertical ? .infinity : nil
            )
    }
}
