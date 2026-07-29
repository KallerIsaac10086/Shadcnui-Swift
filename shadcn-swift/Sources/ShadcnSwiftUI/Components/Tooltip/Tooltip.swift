import SwiftUI

// MARK: - Tooltip Size

public enum TooltipSize: Sendable {
    case sm
    case `default`
    case lg
}

// MARK: - Tooltip Modifier

/// A hover/long-press tooltip. Corresponds to `<Tooltip>` in shadcn/ui.
///
/// iOS: long-press to show. macOS: hover to show.
///
/// Usage:
/// ```swift
/// Text("Hover me")
///     .tooltip("This is a tooltip", size: .default)
/// ```
public struct TooltipModifier: ViewModifier {
    @Environment(\.shadcnToken) private var token

    let text: String
    let size: TooltipSize
    let sideOffset: CGFloat

    @State private var isVisible = false

    public func body(content: Content) -> some View {
        content
        #if os(macOS)
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.15)) { isVisible = hovering }
            }
        #endif
            .onLongPressGesture(minimumDuration: 0.3) {
                withAnimation(.easeInOut(duration: 0.15)) { isVisible = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeInOut(duration: 0.15)) { isVisible = false }
                }
            }
            .overlay(alignment: .top) {
                if isVisible {
                    Text(text)
                        .font(font)
                        .padding(.horizontal, hPad)
                        .padding(.vertical, vPad)
                        .background(token.primary)
                        .foregroundColor(token.primaryForeground)
                        .clipShape(RoundedRectangle(cornerRadius: token.radius / 2))
                        .offset(y: -sideOffset - 8)
                        .transition(.scale(scale: 0.95).combined(with: .opacity))
                }
            }
    }

    private var font: Font {
        switch size {
        case .sm:      return .system(size: 12)
        case .default: return .system(size: 14)
        case .lg:      return .system(size: 16)
        }
    }

    private var hPad: CGFloat {
        switch size {
        case .sm: return 8; case .default: return 12; case .lg: return 16
        }
    }

    private var vPad: CGFloat {
        switch size {
        case .sm: return 2; case .default: return 6; case .lg: return 8
        }
    }
}

public extension View {
    func tooltip(
        _ text: String,
        size: TooltipSize = .default,
        sideOffset: CGFloat = 4
    ) -> some View {
        modifier(TooltipModifier(text: text, size: size, sideOffset: sideOffset))
    }
}
