import SwiftUI

// MARK: - ToggleGroup

/// A group of toggle buttons with merged borders.
///
/// Corresponds to `<ToggleGroup>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// @State var selected: Set<String> = []
/// ToggleGroup(selection: $selected) {
///     ShadcnToggle(isPressed: ...) { Text("Bold") }
///     ShadcnToggle(isPressed: ...) { Text("Italic") }
/// }
/// ```
public struct ToggleGroup<Value: Hashable & Sendable, Content: View>: View {
    @Environment(\.shadcnToken) private var token

    @Binding var selection: Set<Value>
    let size: ShadcnToggleSize
    @ViewBuilder let content: () -> Content

    public init(
        selection: Binding<Set<Value>>,
        size: ShadcnToggleSize = .default,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._selection = selection
        self.size = size
        self.content = content
    }

    public var body: some View {
        HStack(spacing: 0) {
            content()
        }
        .clipShape(RoundedRectangle(cornerRadius: token.radius))
        .overlay(
            RoundedRectangle(cornerRadius: token.radius)
                .strokeBorder(token.border, lineWidth: 1)
        )
    }
}
