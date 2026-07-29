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
    public let destructiveForeground: Color

    // Sidebar
    public let sidebar: Color
    public let sidebarForeground: Color
    public let sidebarPrimary: Color
    public let sidebarPrimaryForeground: Color
    public let sidebarAccent: Color
    public let sidebarAccentForeground: Color
    public let sidebarBorder: Color
    public let sidebarRing: Color

    // Chart
    public let chart1: Color
    public let chart2: Color
    public let chart3: Color
    public let chart4: Color
    public let chart5: Color

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
        destructiveForeground: Color = .white,
        sidebar: Color = .clear,
        sidebarForeground: Color = .clear,
        sidebarPrimary: Color = .clear,
        sidebarPrimaryForeground: Color = .clear,
        sidebarAccent: Color = .clear,
        sidebarAccentForeground: Color = .clear,
        sidebarBorder: Color = .clear,
        sidebarRing: Color = .clear,
        chart1: Color = .clear,
        chart2: Color = .clear,
        chart3: Color = .clear,
        chart4: Color = .clear,
        chart5: Color = .clear,
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
        self.destructiveForeground = destructiveForeground
        self.sidebar = sidebar
        self.sidebarForeground = sidebarForeground
        self.sidebarPrimary = sidebarPrimary
        self.sidebarPrimaryForeground = sidebarPrimaryForeground
        self.sidebarAccent = sidebarAccent
        self.sidebarAccentForeground = sidebarAccentForeground
        self.sidebarBorder = sidebarBorder
        self.sidebarRing = sidebarRing
        self.chart1 = chart1
        self.chart2 = chart2
        self.chart3 = chart3
        self.chart4 = chart4
        self.chart5 = chart5
        self.border = border
        self.input = input
        self.ring = ring
        self.radius = radius
    }
}
