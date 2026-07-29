import SwiftUI

// MARK: - Marker

/// An inline conversation marker (status, divider, date separator). Corresponds to `<Marker>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// Marker("Today")
/// Marker("System: switched branch", variant: .border)
/// Marker("Thinking...", variant: .default)
/// ```
public struct Marker: View {
    @Environment(\.shadcnToken) private var token

    public enum Variant: Sendable {
        case `default`   // lightweight inline text
        case border      // bottom border separator
        case separator   // centered text with side lines
    }

    let text: String
    let variant: Variant

    public init(_ text: String, variant: Variant = .default) {
        self.text = text; self.variant = variant
    }

    public var body: some View {
        switch variant {
        case .default:
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(token.mutedForeground)
                .padding(.vertical, 4)

        case .border:
            VStack(spacing: 0) {
                Text(text)
                    .font(.system(size: 12))
                    .foregroundColor(token.mutedForeground)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 4)
                Rectangle().fill(token.border).frame(height: 1)
            }

        case .separator:
            HStack(spacing: 8) {
                Rectangle().fill(token.border).frame(height: 1)
                Text(text)
                    .font(.system(size: 12))
                    .foregroundColor(token.mutedForeground)
                    .layoutPriority(1)
                Rectangle().fill(token.border).frame(height: 1)
            }
            .padding(.vertical, 8)
        }
    }
}
