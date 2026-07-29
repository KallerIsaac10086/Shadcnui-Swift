import SwiftUI

// MARK: - Switch Size

public enum ShadcnSwitchSize: Sendable {
    case `default`
    case sm
}

// MARK: - Switch Style

/// A shadcn-styled ToggleStyle. Corresponds to `<Switch>` in shadcn/ui.
///
/// 2 sizes (default 32×18.4, sm 24×14). Animated thumb slide.
///
/// Usage:
/// ```swift
/// Toggle("", isOn: $enabled)
///     .toggleStyle(ShadcnSwitchStyle())
/// Toggle("", isOn: $enabled)
///     .toggleStyle(ShadcnSwitchStyle(size: .sm))
/// ```
public struct ShadcnSwitchStyle: ToggleStyle {
    @Environment(\.shadcnToken) private var token
    @Environment(\.isEnabled) private var isEnabled

    let size: ShadcnSwitchSize

    public init(size: ShadcnSwitchSize = .default) {
        self.size = size
    }

    public func makeBody(configuration: Configuration) -> some View {
        let isOn = configuration.isOn
        let trackW: CGFloat = size == .default ? 32 : 24
        let trackH: CGFloat = size == .default ? 18.4 : 14
        let thumbD: CGFloat = size == .default ? 16 : 12

        Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                configuration.isOn.toggle()
            }
        } label: {
            ZStack(alignment: isOn ? .trailing : .leading) {
                // Track
                Capsule()
                    .fill(isOn ? token.primary : token.input)
                    .frame(width: trackW, height: trackH)

                // Thumb
                Circle()
                    .fill(token.background)
                    .frame(width: thumbD, height: thumbD)
                    .padding(2)
            }
        }
        .buttonStyle(.plain)
        .opacity(isEnabled ? 1 : 0.5)
    }
}

// MARK: - Convenience

public extension ToggleStyle where Self == ShadcnSwitchStyle {
    static var shadcnSwitch: ShadcnSwitchStyle { ShadcnSwitchStyle() }
    static func shadcnSwitch(size: ShadcnSwitchSize) -> ShadcnSwitchStyle {
        ShadcnSwitchStyle(size: size)
    }
}
