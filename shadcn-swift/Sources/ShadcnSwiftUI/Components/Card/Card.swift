import SwiftUI

// MARK: - Card

/// The root card container. Corresponds to `<Card>` in shadcn/ui.
///
/// Supports custom styling via `customStyle` — mirrors shadcn/ui's `className` prop.
/// Custom modifiers are applied **after** defaults, so user styles naturally override.
public struct Card<Content: View>: View {
    @Environment(\.shadcnToken) private var token

    let size: CardSize
    let content: () -> Content
    let customStyle: ((AnyView) -> AnyView)?

    public init(
        size: CardSize = .default,
        customStyle: ((AnyView) -> AnyView)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.size = size
        self.content = content
        self.customStyle = customStyle
    }

    public var body: some View {
        let base = AnyView(
            VStack(alignment: .leading, spacing: 0) {
                content()
            }
            .background(token.card)
            .foregroundColor(token.cardForeground)
            .clipShape(RoundedRectangle(cornerRadius: token.radius * 1.5))
            .overlay(
                RoundedRectangle(cornerRadius: token.radius * 1.5)
                    .strokeBorder(token.border, lineWidth: 1)
            )
        )

        if let style = customStyle {
            return style(base)
        }
        return base
    }
}

public enum CardSize: Sendable {
    case `default`
    case sm
}

// MARK: - CardHeader

public struct CardHeader<Content: View>: View {
    let content: () -> Content
    let customStyle: ((AnyView) -> AnyView)?

    public init(
        customStyle: ((AnyView) -> AnyView)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
        self.customStyle = customStyle
    }

    public var body: some View {
        let base = AnyView(
            VStack(alignment: .leading, spacing: 4) {
                content()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        )

        if let style = customStyle {
            return style(base)
        }
        return base
    }
}

// MARK: - CardTitle

/// Card title with optional custom styling (mirrors shadcn/ui `className`).
public struct CardTitle: View {
    let text: String
    let customStyle: ((AnyView) -> AnyView)?

    public init(_ text: String, customStyle: ((AnyView) -> AnyView)? = nil) {
        self.text = text
        self.customStyle = customStyle
    }

    public var body: some View {
        let base = AnyView(
            Text(text)
                .font(.system(size: 16, weight: .semibold))
                .tracking(-0.2)
        )

        if let style = customStyle {
            return style(base)
        }
        return base
    }
}

// MARK: - CardDescription

/// Card description text with optional custom styling (mirrors shadcn/ui `className`).
public struct CardDescription: View {
    let text: String
    let customStyle: ((AnyView) -> AnyView)?

    public init(_ text: String, customStyle: ((AnyView) -> AnyView)? = nil) {
        self.text = text
        self.customStyle = customStyle
    }

    public var body: some View {
        let base = AnyView(
            Text(text)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
        )

        if let style = customStyle {
            return style(base)
        }
        return base
    }
}

// MARK: - CardAction

public struct CardAction<Content: View>: View {
    let content: () -> Content
    let customStyle: ((AnyView) -> AnyView)?

    public init(
        customStyle: ((AnyView) -> AnyView)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
        self.customStyle = customStyle
    }

    public var body: some View {
        let base = AnyView(
            HStack {
                Spacer()
                content()
            }
        )

        if let style = customStyle {
            return style(base)
        }
        return base
    }
}

// MARK: - CardContent

public struct CardContent<Content: View>: View {
    let content: () -> Content
    let customStyle: ((AnyView) -> AnyView)?

    public init(
        customStyle: ((AnyView) -> AnyView)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
        self.customStyle = customStyle
    }

    public var body: some View {
        let base = AnyView(
            VStack(alignment: .leading, spacing: 8) {
                content()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        )

        if let style = customStyle {
            return style(base)
        }
        return base
    }
}

// MARK: - CardFooter

public struct CardFooter<Content: View>: View {
    @Environment(\.shadcnToken) private var token

    let content: () -> Content
    let customStyle: ((AnyView) -> AnyView)?

    public init(
        customStyle: ((AnyView) -> AnyView)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
        self.customStyle = customStyle
    }

    public var body: some View {
        let base = AnyView(
            HStack(spacing: 8) {
                content()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        )

        if let style = customStyle {
            return style(base)
        }
        return base
    }
}
