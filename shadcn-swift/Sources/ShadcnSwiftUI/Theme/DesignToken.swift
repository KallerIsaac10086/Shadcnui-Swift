import SwiftUI

/// Semantic design tokens, mirroring shadcn/ui CSS variables.
///
/// Each token maps to a `--name` CSS variable from shadcn themes.
/// See: `apps/v4/registry/themes.ts`
public struct DesignToken: Sendable {
    // Backgrounds
    public let background: Color
    public let foreground: Color

    // Card
    public let card: Color
    public let cardForeground: Color

    // Popover
    public let popover: Color
    public let popoverForeground: Color

    // Primary
    public let primary: Color
    public let primaryForeground: Color

    // Secondary
    public let secondary: Color
    public let secondaryForeground: Color

    // Muted
    public let muted: Color
    public let mutedForeground: Color

    // Accent
    public let accent: Color
    public let accentForeground: Color

    // Destructive
    public let destructive: Color

    // Borders
    public let border: Color
    public let input: Color
    public let ring: Color

    // Radius
    public let radius: CGFloat

    public init(
        background: Color,
        foreground: Color,
        card: Color,
        cardForeground: Color,
        popover: Color,
        popoverForeground: Color,
        primary: Color,
        primaryForeground: Color,
        secondary: Color,
        secondaryForeground: Color,
        muted: Color,
        mutedForeground: Color,
        accent: Color,
        accentForeground: Color,
        destructive: Color,
        border: Color,
        input: Color,
        ring: Color,
        radius: CGFloat
    ) {
        self.background = background
        self.foreground = foreground
        self.card = card
        self.cardForeground = cardForeground
        self.popover = popover
        self.popoverForeground = popoverForeground
        self.primary = primary
        self.primaryForeground = primaryForeground
        self.secondary = secondary
        self.secondaryForeground = secondaryForeground
        self.muted = muted
        self.mutedForeground = mutedForeground
        self.accent = accent
        self.accentForeground = accentForeground
        self.destructive = destructive
        self.border = border
        self.input = input
        self.ring = ring
        self.radius = radius
    }
}
