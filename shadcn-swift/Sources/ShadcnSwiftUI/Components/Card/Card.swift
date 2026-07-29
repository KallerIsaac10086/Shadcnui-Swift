import SwiftUI

// MARK: - Card

/// The root card container. Corresponds to `<Card>` in shadcn/ui.
public struct Card<Content: View>: View {
    @Environment(\.shadcnToken) private var token

    let size: CardSize
    let content: () -> Content

    public init(size: CardSize = .default, @ViewBuilder content: @escaping () -> Content) {
        self.size = size
        self.content = content
    }

    public var body: some View {
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
    }
}

public enum CardSize: Sendable {
    case `default`
    case sm
}

// MARK: - CardHeader

public struct CardHeader<Content: View>: View {
    let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            content()
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

// MARK: - CardTitle

public struct CardTitle: View {
    let text: String

    public init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        Text(text)
            .font(.system(size: 16, weight: .semibold))
            .tracking(-0.2)
    }
}

// MARK: - CardDescription

public struct CardDescription: View {
    let text: String

    public init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        Text(text)
            .font(.system(size: 14))
            .foregroundStyle(.secondary)
    }
}

// MARK: - CardAction

public struct CardAction<Content: View>: View {
    let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        HStack {
            Spacer()
            content()
        }
    }
}

// MARK: - CardContent

public struct CardContent<Content: View>: View {
    let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            content()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}

// MARK: - CardFooter

public struct CardFooter<Content: View>: View {
    @Environment(\.shadcnToken) private var token

    let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        HStack(spacing: 8) {
            content()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}
