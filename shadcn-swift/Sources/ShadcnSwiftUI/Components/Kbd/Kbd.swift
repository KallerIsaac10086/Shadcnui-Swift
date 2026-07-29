import SwiftUI

// MARK: - Kbd

/// A keyboard key badge. Corresponds to `<Kbd>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// Kbd("⌘")
/// ```
public struct Kbd: View {
    @Environment(\.shadcnToken) private var token
    let key: String

    public init(_ key: String) {
        self.key = key
    }

    public var body: some View {
        Text(key)
            .font(.system(size: 12, design: .monospaced))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(token.muted)
            .foregroundColor(token.foreground)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .strokeBorder(token.border, lineWidth: 1)
            )
    }
}

// MARK: - KbdGroup

/// A group of keyboard keys. Corresponds to `<KbdGroup>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// KbdGroup {
///     Kbd("⌘")
///     Kbd("K")
/// }
/// ```
public struct KbdGroup<Content: View>: View {
    @ViewBuilder let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        HStack(spacing: 4) {
            content()
        }
    }
}
