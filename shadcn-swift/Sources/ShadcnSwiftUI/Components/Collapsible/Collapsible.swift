import SwiftUI

// MARK: - Collapsible

/// A disclosure-style expandable panel. Corresponds to `<Collapsible>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// Collapsible {
///     Text("Show details")
/// } content: {
///     Text("Hidden content here.")
/// }
/// ```
public struct Collapsible<Label: View, Content: View>: View {
    @Environment(\.shadcnToken) private var token
    @State private var isExpanded = false

    let label: () -> Label
    @ViewBuilder let content: () -> Content

    public init(
        @ViewBuilder label: @escaping () -> Label,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.label = label
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) { isExpanded.toggle() }
            } label: {
                HStack {
                    label()
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(token.mutedForeground)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .animation(.easeInOut(duration: 0.2), value: isExpanded)
                }
            }
            .buttonStyle(.borderless)

            if isExpanded {
                content()
                    .padding(.top, 8)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(12)
        .background(token.card)
        .clipShape(RoundedRectangle(cornerRadius: token.radius))
        .overlay(
            RoundedRectangle(cornerRadius: token.radius)
                .strokeBorder(token.border, lineWidth: 1)
        )
    }
}

// MARK: - CollapsibleTrigger (alias)

public typealias CollapsibleTrigger = Collapsible
