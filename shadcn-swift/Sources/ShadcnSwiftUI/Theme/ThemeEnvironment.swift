import SwiftUI

private struct ThemeEnvironmentKey: EnvironmentKey {
    static let defaultValue: DesignToken = Themes.zinc.light
}

public extension EnvironmentValues {
    /// The active shadcn design token, auto-resolved from the current theme + color scheme.
    var shadcnToken: DesignToken {
        get { self[ThemeEnvironmentKey.self] }
        set { self[ThemeEnvironmentKey.self] = newValue }
    }
}

/// A ViewModifier that sets the shadcn theme and automatically
/// toggles between light/dark tokens based on system appearance.
public struct ShadcnThemeModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    let theme: Theme

    public func body(content: Content) -> some View {
        content
            .environment(\.shadcnToken, theme.token(for: colorScheme))
    }
}

public extension View {
    /// Apply a shadcn theme to the view hierarchy.
    func shadcnTheme(_ theme: Theme) -> some View {
        modifier(ShadcnThemeModifier(theme: theme))
    }
}
