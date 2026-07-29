import SwiftUI

// MARK: - Variant

public enum AlertVariant: String, CaseIterable, Sendable {
    case `default`
    case destructive
}

// MARK: - Alert

/// Alert banner with title, description and optional action. 2 variants.
/// Corresponds to `<Alert>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// Alert(variant: .destructive) {
///     AlertTitle("Error")
///     AlertDescription("Something went wrong.")
/// }
/// ```
public struct Alert<Content: View>: View {
    @Environment(\.shadcnToken) private var token

    let variant: AlertVariant
    let content: () -> Content

    public init(variant: AlertVariant = .default, @ViewBuilder content: @escaping () -> Content) {
        self.variant = variant
        self.content = content
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if variant == .destructive {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(token.destructive)
                    .padding(.top, 1)
            }
            VStack(alignment: .leading, spacing: 4) {
                content()
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(token.card)
        .clipShape(RoundedRectangle(cornerRadius: token.radius))
        .overlay(
            RoundedRectangle(cornerRadius: token.radius)
                .strokeBorder(token.border, lineWidth: 1)
        )
    }
}

// MARK: - Sub-components

public struct AlertTitle: View {
    @Environment(\.shadcnToken) private var token
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text).font(.system(size: 14, weight: .medium)).foregroundColor(token.foreground)
    }
}

public struct AlertDescription: View {
    @Environment(\.shadcnToken) private var token
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text).font(.system(size: 14)).foregroundColor(token.mutedForeground)
    }
}

public struct AlertAction<Content: View>: View {
    let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View { content() }
}
