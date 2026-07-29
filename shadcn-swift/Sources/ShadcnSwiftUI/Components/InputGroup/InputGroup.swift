import SwiftUI

// MARK: - InputGroup

/// Groups an input with prefix/suffix addons sharing merged borders.
///
/// Corresponds to `<InputGroup>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// InputGroup {
///     Input("Amount", text: $amount)
///     InputGroupAddon(align: .inlineStart) {
///         InputGroupText("$")
///     }
/// }
/// ```
public struct InputGroup<Content: View>: View {
    @Environment(\.shadcnToken) private var token

    @ViewBuilder let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        HStack(spacing: 0) {
            content()
        }
        .environment(\.suppressInputBorder, true)
        .clipShape(RoundedRectangle(cornerRadius: token.radius))
        .overlay(
            RoundedRectangle(cornerRadius: token.radius)
                .strokeBorder(token.border, lineWidth: 1)
        )
    }
}

// MARK: - Addon Alignment

public enum InputGroupAddonAlign: Sendable {
    case inlineStart
    case inlineEnd
}

// MARK: - InputGroupAddon

/// A prefix or suffix element inside an `InputGroup`.
public struct InputGroupAddon<Content: View>: View {
    @Environment(\.shadcnToken) private var token

    let align: InputGroupAddonAlign
    @ViewBuilder let content: () -> Content

    public init(
        align: InputGroupAddonAlign = .inlineStart,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.align = align
        self.content = content
    }

    public var body: some View {
        content()
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .frame(height: 32)
            .background(token.muted)
            .foregroundColor(token.mutedForeground)
    }
}

// MARK: - InputGroupText

/// Static text inside an `InputGroupAddon` (e.g. "$", "https://").
public struct InputGroupText: View {
    let text: String

    public init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        Text(text)
            .font(.system(size: 14, weight: .medium))
    }
}
