import SwiftUI

// MARK: - Variant

/// Badge variant, matching shadcn/ui's `badgeVariants`.
public enum BadgeVariant: String, CaseIterable, Sendable {
    case `default`
    case secondary
    case destructive
    case outline
    case ghost
    case link
}

// MARK: - Badge

/// Inline badge / tag. Corresponds to `<Badge>` in shadcn/ui.
///
/// 6 variants. Label via `@ViewBuilder` supports text + icon combos.
///
/// Usage:
/// ```swift
/// Badge { Text("New") }
/// Badge(variant: .destructive) { Text("Deleted") }
/// Badge(variant: .outline) {
///     Image(systemName: "checkmark")
///     Text("Done")
/// }
/// ```
public struct Badge<Label: View>: View {
    @Environment(\.shadcnToken) private var token

    let variant: BadgeVariant
    let label: () -> Label
    let customStyle: ((AnyView) -> AnyView)?

    public init(
        variant: BadgeVariant = .default,
        customStyle: ((AnyView) -> AnyView)? = nil,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.variant = variant
        self.customStyle = customStyle
        self.label = label
    }

    public var body: some View {
        let base = AnyView(
            label()
                .font(.system(size: 12, weight: .medium))
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(bgColor)
                .foregroundColor(fgColor)
                .clipShape(Capsule())
                .overlay(borderOverlay)
        )

        if let style = customStyle {
            return style(base)
        }
        return base
    }

    private var bgColor: Color {
        switch variant {
        case .default:     return token.primary
        case .secondary:   return token.secondary
        case .destructive: return token.destructive.opacity(0.1)
        case .outline:     return .clear
        case .ghost:       return .clear
        case .link:        return .clear
        }
    }

    private var fgColor: Color {
        switch variant {
        case .default:     return token.primaryForeground
        case .secondary:   return token.secondaryForeground
        case .destructive: return token.destructive
        case .outline:     return token.foreground
        case .ghost:       return token.mutedForeground
        case .link:        return token.primary
        }
    }

    @ViewBuilder
    private var borderOverlay: some View {
        if variant == .outline {
            Capsule()
                .strokeBorder(token.border, lineWidth: 1)
        }
    }
}

// MARK: - String shorthand

public extension Badge where Label == Text {
    init(
        _ title: String,
        variant: BadgeVariant = .default,
        customStyle: ((AnyView) -> AnyView)? = nil
    ) {
        self.init(variant: variant, customStyle: customStyle) {
            Text(title)
        }
    }
}
