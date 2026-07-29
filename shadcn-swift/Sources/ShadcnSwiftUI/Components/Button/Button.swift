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
public struct ShadcnButtonStyle: ButtonStyle {
    @Environment(\.shadcnToken) private var token
    @Environment(\.isEnabled) private var isEnabled

    let variant: ButtonVariant
    let size: ButtonSize

    public init(variant: ButtonVariant = .default, size: ButtonSize = .default) {
        self.variant = variant
        self.size = size
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(font)
            .frame(height: height)
            .padding(.horizontal, horizontalPadding)
            .background(backgroundColor(isPressed: configuration.isPressed))
            .foregroundColor(foregroundColor)
            .overlay(borderOverlay)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .opacity(isEnabled ? 1.0 : 0.5)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
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

    private var cornerRadius: CGFloat {
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
            return .white
        case .link:
            return token.primary
        }
    }

    @ViewBuilder
    private var borderOverlay: some View {
        switch variant {
        case .outline:
            RoundedRectangle(cornerRadius: cornerRadius)
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
/// Button("Click me") { action() }
///     .shadcnButton(variant: .outline, size: .lg)
/// ```
public struct ShadcnButton<Label: View>: View {
    let variant: ButtonVariant
    let size: ButtonSize
    let action: () -> Void
    let label: () -> Label

    public init(
        variant: ButtonVariant = .default,
        size: ButtonSize = .default,
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.variant = variant
        self.size = size
        self.action = action
        self.label = label
    }

    public var body: some View {
        Button(action: action, label: label)
            .buttonStyle(ShadcnButtonStyle(variant: variant, size: size))
    }
}

// MARK: - Convenience Modifier

public extension View {
    /// Apply shadcn button styling to any Button or tappable view.
    func shadcnButton(variant: ButtonVariant = .default, size: ButtonSize = .default) -> some View {
        self.buttonStyle(ShadcnButtonStyle(variant: variant, size: size))
    }
}

// MARK: - String label shorthand

public extension ShadcnButton where Label == Text {
    init(
        _ title: String,
        variant: ButtonVariant = .default,
        size: ButtonSize = .default,
        action: @escaping () -> Void
    ) {
        self.init(variant: variant, size: size, action: action) {
            Text(title)
        }
    }
}
