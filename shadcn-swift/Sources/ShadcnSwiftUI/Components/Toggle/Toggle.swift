import SwiftUI

// MARK: - Variant & Size

public enum ShadcnToggleVariant: String, CaseIterable, Sendable {
    case `default`
    case outline
}

public enum ShadcnToggleSize: Sendable {
    case sm
    case `default`
    case lg
}

// MARK: - Toggle

/// Toggle button with pressed state. Corresponds to `<Toggle>` in shadcn/ui.
///
/// 2 variants (default/outline), 3 sizes (sm/default/lg).
///
/// Usage:
/// ```swift
/// Toggle(isPressed: $pressed) {
///     Image(systemName: "bold")
/// }
/// ```
public struct ShadcnToggle<Label: View>: View {
    @Environment(\.shadcnToken) private var token

    let variant: ShadcnToggleVariant
    let size: ShadcnToggleSize
    @Binding var isPressed: Bool
    let label: () -> Label

    public init(
        variant: ShadcnToggleVariant = .default,
        size: ShadcnToggleSize = .default,
        isPressed: Binding<Bool>,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.variant = variant
        self.size = size
        self._isPressed = isPressed
        self.label = label
    }

    public var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.15)) { isPressed.toggle() }
        } label: {
            label()
                .font(font)
                .foregroundColor(token.foreground)
                .frame(height: height)
                .padding(.horizontal, hPad)
                .background(isPressed ? token.muted : (variant == .outline ? .clear : .clear))
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .overlay(borderOverlay)
        }
        .buttonStyle(.plain)
    }

    private var height: CGFloat {
        switch size {
        case .sm:      return 28
        case .default: return 32
        case .lg:      return 36
        }
    }

    private var hPad: CGFloat {
        switch size {
        case .sm:      return 8
        case .default: return 10
        case .lg:      return 12
        }
    }

    private var font: Font {
        switch size {
        case .sm:      return .system(size: 13, weight: .medium)
        case .default: return .system(size: 14, weight: .medium)
        case .lg:      return .system(size: 15, weight: .medium)
        }
    }

    private var cornerRadius: CGFloat { token.radius }

    @ViewBuilder
    private var borderOverlay: some View {
        if variant == .outline {
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(isPressed ? token.primary : token.border, lineWidth: 1)
        }
    }
}
