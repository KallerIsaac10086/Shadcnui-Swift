import SwiftUI

// MARK: - Variant Definitions

/// Button variant, matching shadcn/ui's `buttonVariants.variant`.
public enum ButtonVariant: String, CaseIterable, Sendable {
    case `default`
    case outline
    case secondary
    case ghost
    case destructive
    case link
}

/// Button size, matching shadcn/ui's `buttonVariants.size`.
public enum ButtonSize: String, CaseIterable, Sendable {
    case `default`
    case xs
    case sm
    case lg
    case icon
    case iconXs  = "icon-xs"
    case iconSm  = "icon-sm"
    case iconLg  = "icon-lg"
}

// MARK: - Button Style

/// The SwiftUI ButtonStyle that maps variant + size to visual appearance.
///
/// Supports custom styling via `labelModifier` — mirrors shadcn/ui's `className` prop.
/// Custom modifiers are applied **after** defaults, so they naturally override.
public struct ShadcnButtonStyle: ButtonStyle {
    @Environment(\.shadcnToken) private var token
    @Environment(\.isEnabled) private var isEnabled

    let variant: ButtonVariant
    let size: ButtonSize
    let cornerRadius: CGFloat?

    /// Optional closure to customize the styled label.
    /// Applied after all default styles — mimics shadcn/ui `cn(defaults, className)`.
    let labelModifier: ((AnyView) -> AnyView)?

    public init(
        variant: ButtonVariant = .default,
        size: ButtonSize = .default,
        cornerRadius: CGFloat? = nil,
        labelModifier: ((AnyView) -> AnyView)? = nil
    ) {
        self.variant = variant
        self.size = size
        self.cornerRadius = cornerRadius
        self.labelModifier = labelModifier
    }

    public func makeBody(configuration: Configuration) -> some View {
        let base = AnyView(
            configuration.label
                .font(font)
                .frame(height: height)
                .padding(.horizontal, horizontalPadding)
                .background(backgroundColor(isPressed: configuration.isPressed))
                .foregroundColor(foregroundColor)
                .overlay(borderOverlay)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius_))
                .opacity(isEnabled ? 1.0 : 0.5)
                .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
                .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
        )

        if let modifier = labelModifier {
            return modifier(base)
        }
        return base
    }

    // MARK: - Size Computations

    private var height: CGFloat {
        switch size {
        case .default: return 36
        case .xs:      return 28
        case .sm:      return 32
        case .lg:      return 40
        case .icon:    return 36
        case .iconXs:  return 28
        case .iconSm:  return 32
        case .iconLg:  return 40
        }
    }

    private var horizontalPadding: CGFloat {
        switch size {
        case .default: return 14
        case .xs:      return 8
        case .sm:      return 10
        case .lg:      return 18
        case .icon, .iconXs, .iconSm, .iconLg: return 0
        }
    }

    private var font: Font {
        switch size {
        case .default: return .system(size: 14, weight: .medium)
        case .xs:      return .system(size: 12, weight: .medium)
        case .sm:      return .system(size: 13, weight: .medium)
        case .lg:      return .system(size: 15, weight: .medium)
        case .icon, .iconXs: return .system(size: 14)
        case .iconSm:  return .system(size: 13)
        case .iconLg:  return .system(size: 15)
        }
    }

    private var cornerRadius_: CGFloat {
        if let cornerRadius { return cornerRadius }
        switch size {
        case .icon, .iconXs, .iconSm, .iconLg:
            return height / 2  // Fully rounded for icon buttons
        default:
            return token.radius
        }
    }

    // MARK: - Variant Styles

    private func backgroundColor(isPressed: Bool) -> Color {
        let base: Color
        switch variant {
        case .default:
            base = token.primary
        case .outline, .ghost, .link:
            base = .clear
        case .secondary:
            base = token.secondary
        case .destructive:
            base = token.destructive
        }
        if isPressed && variant != .link {
            return base.opacity(0.8)
        }
        return base
    }

    private var foregroundColor: Color {
        switch variant {
        case .default:
            return token.primaryForeground
        case .outline, .ghost:
            return token.foreground
        case .secondary:
            return token.secondaryForeground
        case .destructive:
            return token.destructiveForeground
        case .link:
            return token.primary
        }
    }

    @ViewBuilder
    private var borderOverlay: some View {
        switch variant {
        case .outline:
            RoundedRectangle(cornerRadius: cornerRadius_)
                .strokeBorder(token.border, lineWidth: 1)
        default:
            EmptyView()
        }
    }
}

// MARK: - Button View

/// A shadcn-styled Button that uses `ShadcnButtonStyle`.
///
/// Usage:
/// ```swift
/// // Basic
/// ShadcnButton("Click me") { action() }
///
/// // With custom style (like shadcn/ui className)
/// ShadcnButton("Delete", variant: .destructive) { action() } customStyle: { label in
///     AnyView(label.cornerRadius(20).frame(maxWidth: .infinity))
/// }
/// ```
public struct ShadcnButton<Label: View>: View {
    let variant: ButtonVariant
    let size: ButtonSize
    let cornerRadius: CGFloat?
    let action: () -> Void
    let label: () -> Label
    let customStyle: ((AnyView) -> AnyView)?

    public init(
        variant: ButtonVariant = .default,
        size: ButtonSize = .default,
        cornerRadius: CGFloat? = nil,
        action: @escaping () -> Void,
        customStyle: ((AnyView) -> AnyView)? = nil,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.variant = variant
        self.size = size
        self.cornerRadius = cornerRadius
        self.action = action
        self.label = label
        self.customStyle = customStyle
    }

    public var body: some View {
        Button(action: action, label: label)
            .buttonStyle(ShadcnButtonStyle(variant: variant, size: size, cornerRadius: cornerRadius, labelModifier: customStyle))
    }
}

// MARK: - Convenience Modifier

public extension View {
    /// Apply shadcn button styling to any Button or tappable view.
    ///
    /// The optional `customStyle` closure receives the fully-styled label and lets you
    /// apply additional / overriding modifiers — the SwiftUI analog of shadcn/ui's `className`.
    ///
    /// ```swift
    /// Button("Delete") { }
    ///     .shadcnButton(variant: .destructive, size: .lg) { label in
    ///         AnyView(label.cornerRadius(20).frame(maxWidth: .infinity))
    ///     }
    /// ```
    func shadcnButton(
        variant: ButtonVariant = .default,
        size: ButtonSize = .default,
        cornerRadius: CGFloat? = nil,
        customStyle: ((AnyView) -> AnyView)? = nil
    ) -> some View {
        self.buttonStyle(ShadcnButtonStyle(variant: variant, size: size, cornerRadius: cornerRadius, labelModifier: customStyle))
    }
}

// MARK: - String label shorthand

public extension ShadcnButton where Label == Text {
    init(
        _ title: String,
        variant: ButtonVariant = .default,
        size: ButtonSize = .default,
        cornerRadius: CGFloat? = nil,
        action: @escaping () -> Void,
        customStyle: ((AnyView) -> AnyView)? = nil
    ) {
        self.init(variant: variant, size: size, cornerRadius: cornerRadius, action: action, customStyle: customStyle) {
            Text(title)
        }
    }
}
