import SwiftUI

/// A theme = a name + light token set + dark token set.
public struct Theme: Sendable {
    public let name: String
    public let light: DesignToken
    public let dark: DesignToken

    public init(name: String, light: DesignToken, dark: DesignToken) {
        self.name = name
        self.light = light
        self.dark = dark
    }

    /// Return the appropriate token for the given color scheme.
    public func token(for scheme: ColorScheme) -> DesignToken {
        scheme == .dark ? dark : light
    }
}
