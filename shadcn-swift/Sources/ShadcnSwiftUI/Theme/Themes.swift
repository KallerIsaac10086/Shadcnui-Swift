import SwiftUI

// MARK: - Built-in Themes
//
// Directly ported from `apps/v4/registry/themes.ts`.
// Each theme has light + dark token sets.

public enum Themes {

    // ── Base Colors ──────────────────────────────────────────────

    public static let neutral = Theme(
        name: "neutral",
        light: DesignToken(
            background: .oklch("oklch(1 0 0)"),
            foreground: .oklch("oklch(0.145 0 0)"),
            card: .oklch("oklch(1 0 0)"),
            cardForeground: .oklch("oklch(0.145 0 0)"),
            popover: .oklch("oklch(1 0 0)"),
            popoverForeground: .oklch("oklch(0.145 0 0)"),
            primary: .oklch("oklch(0.205 0 0)"),
            primaryForeground: .oklch("oklch(0.985 0 0)"),
            secondary: .oklch("oklch(0.97 0 0)"),
            secondaryForeground: .oklch("oklch(0.205 0 0)"),
            muted: .oklch("oklch(0.97 0 0)"),
            mutedForeground: .oklch("oklch(0.556 0 0)"),
            accent: .oklch("oklch(0.97 0 0)"),
            accentForeground: .oklch("oklch(0.205 0 0)"),
            destructive: .oklch("oklch(0.577 0.245 27.325)"),
            border: .oklch("oklch(0.922 0 0)"),
            input: .oklch("oklch(0.922 0 0)"),
            ring: .oklch("oklch(0.708 0 0)"),
            radius: 10
        ),
        dark: DesignToken(
            background: .oklch("oklch(0.145 0 0)"),
            foreground: .oklch("oklch(0.985 0 0)"),
            card: .oklch("oklch(0.205 0 0)"),
            cardForeground: .oklch("oklch(0.985 0 0)"),
            popover: .oklch("oklch(0.205 0 0)"),
            popoverForeground: .oklch("oklch(0.985 0 0)"),
            primary: .oklch("oklch(0.922 0 0)"),
            primaryForeground: .oklch("oklch(0.205 0 0)"),
            secondary: .oklch("oklch(0.269 0 0)"),
            secondaryForeground: .oklch("oklch(0.985 0 0)"),
            muted: .oklch("oklch(0.269 0 0)"),
            mutedForeground: .oklch("oklch(0.708 0 0)"),
            accent: .oklch("oklch(0.269 0 0)"),
            accentForeground: .oklch("oklch(0.985 0 0)"),
            destructive: .oklch("oklch(0.704 0.191 22.216)"),
            border: .oklch("oklch(1 0 0 / 10%)"),
            input: .oklch("oklch(1 0 0 / 15%)"),
            ring: .oklch("oklch(0.556 0 0)"),
            radius: 10
        )
    )

    public static let zinc = Theme(
        name: "zinc",
        light: DesignToken(
            background: .oklch("oklch(1 0 0)"),
            foreground: .oklch("oklch(0.141 0.005 285.823)"),
            card: .oklch("oklch(1 0 0)"),
            cardForeground: .oklch("oklch(0.141 0.005 285.823)"),
            popover: .oklch("oklch(1 0 0)"),
            popoverForeground: .oklch("oklch(0.141 0.005 285.823)"),
            primary: .oklch("oklch(0.21 0.006 285.885)"),
            primaryForeground: .oklch("oklch(0.985 0 0)"),
            secondary: .oklch("oklch(0.967 0.001 286.375)"),
            secondaryForeground: .oklch("oklch(0.21 0.006 285.885)"),
            muted: .oklch("oklch(0.967 0.001 286.375)"),
            mutedForeground: .oklch("oklch(0.552 0.016 285.938)"),
            accent: .oklch("oklch(0.967 0.001 286.375)"),
            accentForeground: .oklch("oklch(0.21 0.006 285.885)"),
            destructive: .oklch("oklch(0.577 0.245 27.325)"),
            border: .oklch("oklch(0.92 0.004 286.32)"),
            input: .oklch("oklch(0.92 0.004 286.32)"),
            ring: .oklch("oklch(0.705 0.015 286.067)"),
            radius: 10
        ),
        dark: DesignToken(
            background: .oklch("oklch(0.141 0.005 285.823)"),
            foreground: .oklch("oklch(0.985 0 0)"),
            card: .oklch("oklch(0.21 0.006 285.885)"),
            cardForeground: .oklch("oklch(0.985 0 0)"),
            popover: .oklch("oklch(0.21 0.006 285.885)"),
            popoverForeground: .oklch("oklch(0.985 0 0)"),
            primary: .oklch("oklch(0.92 0.004 286.32)"),
            primaryForeground: .oklch("oklch(0.21 0.006 285.885)"),
            secondary: .oklch("oklch(0.274 0.006 286.033)"),
            secondaryForeground: .oklch("oklch(0.985 0 0)"),
            muted: .oklch("oklch(0.274 0.006 286.033)"),
            mutedForeground: .oklch("oklch(0.705 0.015 286.067)"),
            accent: .oklch("oklch(0.274 0.006 286.033)"),
            accentForeground: .oklch("oklch(0.985 0 0)"),
            destructive: .oklch("oklch(0.704 0.191 22.216)"),
            border: .oklch("oklch(1 0 0 / 10%)"),
            input: .oklch("oklch(1 0 0 / 15%)"),
            ring: .oklch("oklch(0.552 0.016 285.938)"),
            radius: 10
        )
    )

    // ── Accent Colors ────────────────────────────────────────────

    public static let rose = Theme(
        name: "rose",
        light: DesignToken(
            background: .oklch("oklch(1 0 0)"),
            foreground: .oklch("oklch(0.141 0.005 285.823)"),
            card: .oklch("oklch(1 0 0)"),
            cardForeground: .oklch("oklch(0.141 0.005 285.823)"),
            popover: .oklch("oklch(1 0 0)"),
            popoverForeground: .oklch("oklch(0.141 0.005 285.823)"),
            primary: .oklch("oklch(0.586 0.253 17.585)"),
            primaryForeground: .oklch("oklch(0.969 0.015 12.422)"),
            secondary: .oklch("oklch(0.967 0.001 286.375)"),
            secondaryForeground: .oklch("oklch(0.21 0.006 285.885)"),
            muted: .oklch("oklch(0.967 0.001 286.375)"),
            mutedForeground: .oklch("oklch(0.552 0.016 285.938)"),
            accent: .oklch("oklch(0.967 0.001 286.375)"),
            accentForeground: .oklch("oklch(0.21 0.006 285.885)"),
            destructive: .oklch("oklch(0.577 0.245 27.325)"),
            border: .oklch("oklch(0.92 0.004 286.32)"),
            input: .oklch("oklch(0.92 0.004 286.32)"),
            ring: .oklch("oklch(0.705 0.015 286.067)"),
            radius: 10
        ),
        dark: DesignToken(
            background: .oklch("oklch(0.141 0.005 285.823)"),
            foreground: .oklch("oklch(0.985 0 0)"),
            card: .oklch("oklch(0.21 0.006 285.885)"),
            cardForeground: .oklch("oklch(0.985 0 0)"),
            popover: .oklch("oklch(0.21 0.006 285.885)"),
            popoverForeground: .oklch("oklch(0.985 0 0)"),
            primary: .oklch("oklch(0.514 0.222 16.935)"),
            primaryForeground: .oklch("oklch(0.969 0.015 12.422)"),
            secondary: .oklch("oklch(0.274 0.006 286.033)"),
            secondaryForeground: .oklch("oklch(0.985 0 0)"),
            muted: .oklch("oklch(0.274 0.006 286.033)"),
            mutedForeground: .oklch("oklch(0.705 0.015 286.067)"),
            accent: .oklch("oklch(0.274 0.006 286.033)"),
            accentForeground: .oklch("oklch(0.985 0 0)"),
            destructive: .oklch("oklch(0.704 0.191 22.216)"),
            border: .oklch("oklch(1 0 0 / 10%)"),
            input: .oklch("oklch(1 0 0 / 15%)"),
            ring: .oklch("oklch(0.552 0.016 285.938)"),
            radius: 10
        )
    )

    public static let orange = Theme(
        name: "orange",
        light: DesignToken(
            background: .oklch("oklch(1 0 0)"),
            foreground: .oklch("oklch(0.141 0.005 285.823)"),
            card: .oklch("oklch(1 0 0)"),
            cardForeground: .oklch("oklch(0.141 0.005 285.823)"),
            popover: .oklch("oklch(1 0 0)"),
            popoverForeground: .oklch("oklch(0.141 0.005 285.823)"),
            primary: .oklch("oklch(0.646 0.222 41.116)"),
            primaryForeground: .oklch("oklch(0.985 0 0)"),
            secondary: .oklch("oklch(0.967 0.001 286.375)"),
            secondaryForeground: .oklch("oklch(0.21 0.006 285.885)"),
            muted: .oklch("oklch(0.967 0.001 286.375)"),
            mutedForeground: .oklch("oklch(0.552 0.016 285.938)"),
            accent: .oklch("oklch(0.967 0.001 286.375)"),
            accentForeground: .oklch("oklch(0.21 0.006 285.885)"),
            destructive: .oklch("oklch(0.577 0.245 27.325)"),
            border: .oklch("oklch(0.92 0.004 286.32)"),
            input: .oklch("oklch(0.92 0.004 286.32)"),
            ring: .oklch("oklch(0.705 0.015 286.067)"),
            radius: 10
        ),
        dark: DesignToken(
            background: .oklch("oklch(0.141 0.005 285.823)"),
            foreground: .oklch("oklch(0.985 0 0)"),
            card: .oklch("oklch(0.21 0.006 285.885)"),
            cardForeground: .oklch("oklch(0.985 0 0)"),
            popover: .oklch("oklch(0.21 0.006 285.885)"),
            popoverForeground: .oklch("oklch(0.985 0 0)"),
            primary: .oklch("oklch(0.554 0.195 38.402)"),
            primaryForeground: .oklch("oklch(0.985 0 0)"),
            secondary: .oklch("oklch(0.274 0.006 286.033)"),
            secondaryForeground: .oklch("oklch(0.985 0 0)"),
            muted: .oklch("oklch(0.274 0.006 286.033)"),
            mutedForeground: .oklch("oklch(0.705 0.015 286.067)"),
            accent: .oklch("oklch(0.274 0.006 286.033)"),
            accentForeground: .oklch("oklch(0.985 0 0)"),
            destructive: .oklch("oklch(0.704 0.191 22.216)"),
            border: .oklch("oklch(1 0 0 / 10%)"),
            input: .oklch("oklch(1 0 0 / 15%)"),
            ring: .oklch("oklch(0.552 0.016 285.938)"),
            radius: 10
        )
    )

    public static let green = Theme(
        name: "green",
        light: DesignToken(
            background: .oklch("oklch(1 0 0)"),
            foreground: .oklch("oklch(0.141 0.005 285.823)"),
            card: .oklch("oklch(1 0 0)"),
            cardForeground: .oklch("oklch(0.141 0.005 285.823)"),
            popover: .oklch("oklch(1 0 0)"),
            popoverForeground: .oklch("oklch(0.141 0.005 285.823)"),
            primary: .oklch("oklch(0.596 0.145 163.225)"),
            primaryForeground: .oklch("oklch(0.985 0 0)"),
            secondary: .oklch("oklch(0.967 0.001 286.375)"),
            secondaryForeground: .oklch("oklch(0.21 0.006 285.885)"),
            muted: .oklch("oklch(0.967 0.001 286.375)"),
            mutedForeground: .oklch("oklch(0.552 0.016 285.938)"),
            accent: .oklch("oklch(0.967 0.001 286.375)"),
            accentForeground: .oklch("oklch(0.21 0.006 285.885)"),
            destructive: .oklch("oklch(0.577 0.245 27.325)"),
            border: .oklch("oklch(0.92 0.004 286.32)"),
            input: .oklch("oklch(0.92 0.004 286.32)"),
            ring: .oklch("oklch(0.705 0.015 286.067)"),
            radius: 10
        ),
        dark: DesignToken(
            background: .oklch("oklch(0.141 0.005 285.823)"),
            foreground: .oklch("oklch(0.985 0 0)"),
            card: .oklch("oklch(0.21 0.006 285.885)"),
            cardForeground: .oklch("oklch(0.985 0 0)"),
            popover: .oklch("oklch(0.21 0.006 285.885)"),
            popoverForeground: .oklch("oklch(0.985 0 0)"),
            primary: .oklch("oklch(0.508 0.118 165.612)"),
            primaryForeground: .oklch("oklch(0.985 0 0)"),
            secondary: .oklch("oklch(0.274 0.006 286.033)"),
            secondaryForeground: .oklch("oklch(0.985 0 0)"),
            muted: .oklch("oklch(0.274 0.006 286.033)"),
            mutedForeground: .oklch("oklch(0.705 0.015 286.067)"),
            accent: .oklch("oklch(0.274 0.006 286.033)"),
            accentForeground: .oklch("oklch(0.985 0 0)"),
            destructive: .oklch("oklch(0.704 0.191 22.216)"),
            border: .oklch("oklch(1 0 0 / 10%)"),
            input: .oklch("oklch(1 0 0 / 15%)"),
            ring: .oklch("oklch(0.552 0.016 285.938)"),
            radius: 10
        )
    )

    public static let violet = Theme(
        name: "violet",
        light: DesignToken(
            background: .oklch("oklch(1 0 0)"),
            foreground: .oklch("oklch(0.141 0.005 285.823)"),
            card: .oklch("oklch(1 0 0)"),
            cardForeground: .oklch("oklch(0.141 0.005 285.823)"),
            popover: .oklch("oklch(1 0 0)"),
            popoverForeground: .oklch("oklch(0.141 0.005 285.823)"),
            primary: .oklch("oklch(0.541 0.281 293.009)"),
            primaryForeground: .oklch("oklch(0.969 0.016 293.756)"),
            secondary: .oklch("oklch(0.967 0.001 286.375)"),
            secondaryForeground: .oklch("oklch(0.21 0.006 285.885)"),
            muted: .oklch("oklch(0.967 0.001 286.375)"),
            mutedForeground: .oklch("oklch(0.552 0.016 285.938)"),
            accent: .oklch("oklch(0.967 0.001 286.375)"),
            accentForeground: .oklch("oklch(0.21 0.006 285.885)"),
            destructive: .oklch("oklch(0.577 0.245 27.325)"),
            border: .oklch("oklch(0.92 0.004 286.32)"),
            input: .oklch("oklch(0.92 0.004 286.32)"),
            ring: .oklch("oklch(0.705 0.015 286.067)"),
            radius: 10
        ),
        dark: DesignToken(
            background: .oklch("oklch(0.141 0.005 285.823)"),
            foreground: .oklch("oklch(0.985 0 0)"),
            card: .oklch("oklch(0.21 0.006 285.885)"),
            cardForeground: .oklch("oklch(0.985 0 0)"),
            popover: .oklch("oklch(0.21 0.006 285.885)"),
            popoverForeground: .oklch("oklch(0.985 0 0)"),
            primary: .oklch("oklch(0.457 0.24 292.771)"),
            primaryForeground: .oklch("oklch(0.969 0.016 293.756)"),
            secondary: .oklch("oklch(0.274 0.006 286.033)"),
            secondaryForeground: .oklch("oklch(0.985 0 0)"),
            muted: .oklch("oklch(0.274 0.006 286.033)"),
            mutedForeground: .oklch("oklch(0.705 0.015 286.067)"),
            accent: .oklch("oklch(0.274 0.006 286.033)"),
            accentForeground: .oklch("oklch(0.985 0 0)"),
            destructive: .oklch("oklch(0.704 0.191 22.216)"),
            border: .oklch("oklch(1 0 0 / 10%)"),
            input: .oklch("oklch(1 0 0 / 15%)"),
            ring: .oklch("oklch(0.552 0.016 285.938)"),
            radius: 10
        )
    )

    public static let blue = Theme(
        name: "blue",
        light: DesignToken(
            background: .oklch("oklch(1 0 0)"),
            foreground: .oklch("oklch(0.141 0.005 285.823)"),
            card: .oklch("oklch(1 0 0)"),
            cardForeground: .oklch("oklch(0.141 0.005 285.823)"),
            popover: .oklch("oklch(1 0 0)"),
            popoverForeground: .oklch("oklch(0.141 0.005 285.823)"),
            primary: .oklch("oklch(0.488 0.243 264.376)"),
            primaryForeground: .oklch("oklch(0.97 0.014 254.604)"),
            secondary: .oklch("oklch(0.967 0.001 286.375)"),
            secondaryForeground: .oklch("oklch(0.21 0.006 285.885)"),
            muted: .oklch("oklch(0.967 0.001 286.375)"),
            mutedForeground: .oklch("oklch(0.552 0.016 285.938)"),
            accent: .oklch("oklch(0.967 0.001 286.375)"),
            accentForeground: .oklch("oklch(0.21 0.006 285.885)"),
            destructive: .oklch("oklch(0.577 0.245 27.325)"),
            border: .oklch("oklch(0.92 0.004 286.32)"),
            input: .oklch("oklch(0.92 0.004 286.32)"),
            ring: .oklch("oklch(0.705 0.015 286.067)"),
            radius: 10
        ),
        dark: DesignToken(
            background: .oklch("oklch(0.141 0.005 285.823)"),
            foreground: .oklch("oklch(0.985 0 0)"),
            card: .oklch("oklch(0.21 0.006 285.885)"),
            cardForeground: .oklch("oklch(0.985 0 0)"),
            popover: .oklch("oklch(0.21 0.006 285.885)"),
            popoverForeground: .oklch("oklch(0.985 0 0)"),
            primary: .oklch("oklch(0.424 0.199 265.638)"),
            primaryForeground: .oklch("oklch(0.97 0.014 254.604)"),
            secondary: .oklch("oklch(0.274 0.006 286.033)"),
            secondaryForeground: .oklch("oklch(0.985 0 0)"),
            muted: .oklch("oklch(0.274 0.006 286.033)"),
            mutedForeground: .oklch("oklch(0.705 0.015 286.067)"),
            accent: .oklch("oklch(0.274 0.006 286.033)"),
            accentForeground: .oklch("oklch(0.985 0 0)"),
            destructive: .oklch("oklch(0.704 0.191 22.216)"),
            border: .oklch("oklch(1 0 0 / 10%)"),
            input: .oklch("oklch(1 0 0 / 15%)"),
            ring: .oklch("oklch(0.552 0.016 285.938)"),
            radius: 10
        )
    )

    public static let stone = Theme(
        name: "stone",
        light: DesignToken(
            background: .oklch("oklch(1 0 0)"),
            foreground: .oklch("oklch(0.147 0.004 49.25)"),
            card: .oklch("oklch(1 0 0)"),
            cardForeground: .oklch("oklch(0.147 0.004 49.25)"),
            popover: .oklch("oklch(1 0 0)"),
            popoverForeground: .oklch("oklch(0.147 0.004 49.25)"),
            primary: .oklch("oklch(0.216 0.006 56.043)"),
            primaryForeground: .oklch("oklch(0.985 0.001 106.423)"),
            secondary: .oklch("oklch(0.97 0.001 106.424)"),
            secondaryForeground: .oklch("oklch(0.216 0.006 56.043)"),
            muted: .oklch("oklch(0.97 0.001 106.424)"),
            mutedForeground: .oklch("oklch(0.553 0.013 58.071)"),
            accent: .oklch("oklch(0.97 0.001 106.424)"),
            accentForeground: .oklch("oklch(0.216 0.006 56.043)"),
            destructive: .oklch("oklch(0.577 0.245 27.325)"),
            border: .oklch("oklch(0.923 0.003 48.717)"),
            input: .oklch("oklch(0.923 0.003 48.717)"),
            ring: .oklch("oklch(0.709 0.01 56.259)"),
            radius: 10
        ),
        dark: DesignToken(
            background: .oklch("oklch(0.147 0.004 49.25)"),
            foreground: .oklch("oklch(0.985 0.001 106.423)"),
            card: .oklch("oklch(0.216 0.006 56.043)"),
            cardForeground: .oklch("oklch(0.985 0.001 106.423)"),
            popover: .oklch("oklch(0.216 0.006 56.043)"),
            popoverForeground: .oklch("oklch(0.985 0.001 106.423)"),
            primary: .oklch("oklch(0.923 0.003 48.717)"),
            primaryForeground: .oklch("oklch(0.216 0.006 56.043)"),
            secondary: .oklch("oklch(0.268 0.007 34.298)"),
            secondaryForeground: .oklch("oklch(0.985 0.001 106.423)"),
            muted: .oklch("oklch(0.268 0.007 34.298)"),
            mutedForeground: .oklch("oklch(0.709 0.01 56.259)"),
            accent: .oklch("oklch(0.268 0.007 34.298)"),
            accentForeground: .oklch("oklch(0.985 0.001 106.423)"),
            destructive: .oklch("oklch(0.704 0.191 22.216)"),
            border: .oklch("oklch(1 0 0 / 10%)"),
            input: .oklch("oklch(1 0 0 / 15%)"),
            ring: .oklch("oklch(0.553 0.013 58.071)"),
            radius: 10
        )
    )

    // ── Additional Accent Colors ──────────────────────────────

    public static let red = Theme(
        name: "red",
        light: DesignToken(
            background: .oklch("oklch(1 0 0)"), foreground: .oklch("oklch(0.141 0.005 285.823)"),
            card: .oklch("oklch(1 0 0)"), cardForeground: .oklch("oklch(0.141 0.005 285.823)"),
            popover: .oklch("oklch(1 0 0)"), popoverForeground: .oklch("oklch(0.141 0.005 285.823)"),
            primary: .oklch("oklch(0.577 0.245 27.325)"), primaryForeground: .oklch("oklch(0.971 0.013 17.38)"),
            secondary: .oklch("oklch(0.967 0.001 286.375)"), secondaryForeground: .oklch("oklch(0.21 0.006 285.885)"),
            muted: .oklch("oklch(0.967 0.001 286.375)"), mutedForeground: .oklch("oklch(0.552 0.016 285.938)"),
            accent: .oklch("oklch(0.967 0.001 286.375)"), accentForeground: .oklch("oklch(0.21 0.006 285.885)"),
            destructive: .oklch("oklch(0.577 0.245 27.325)"), border: .oklch("oklch(0.92 0.004 286.32)"),
            input: .oklch("oklch(0.92 0.004 286.32)"), ring: .oklch("oklch(0.577 0.245 27.325)"), radius: 10
        ),
        dark: DesignToken(
            background: .oklch("oklch(0.141 0.005 285.823)"), foreground: .oklch("oklch(0.985 0 0)"),
            card: .oklch("oklch(0.21 0.006 285.885)"), cardForeground: .oklch("oklch(0.985 0 0)"),
            popover: .oklch("oklch(0.21 0.006 285.885)"), popoverForeground: .oklch("oklch(0.985 0 0)"),
            primary: .oklch("oklch(0.704 0.191 22.216)"), primaryForeground: .oklch("oklch(0.971 0.013 17.38)"),
            secondary: .oklch("oklch(0.274 0.006 286.033)"), secondaryForeground: .oklch("oklch(0.985 0 0)"),
            muted: .oklch("oklch(0.274 0.006 286.033)"), mutedForeground: .oklch("oklch(0.705 0.015 286.067)"),
            accent: .oklch("oklch(0.274 0.006 286.033)"), accentForeground: .oklch("oklch(0.985 0 0)"),
            destructive: .oklch("oklch(0.704 0.191 22.216)"), border: .oklch("oklch(1 0 0 / 10%)"),
            input: .oklch("oklch(1 0 0 / 15%)"), ring: .oklch("oklch(0.552 0.016 285.938)"), radius: 10
        )
    )

    public static let yellow = Theme(
        name: "yellow",
        light: DesignToken(
            background: .oklch("oklch(1 0 0)"), foreground: .oklch("oklch(0.141 0.005 285.823)"),
            card: .oklch("oklch(1 0 0)"), cardForeground: .oklch("oklch(0.141 0.005 285.823)"),
            popover: .oklch("oklch(1 0 0)"), popoverForeground: .oklch("oklch(0.141 0.005 285.823)"),
            primary: .oklch("oklch(0.795 0.184 86.047)"), primaryForeground: .oklch("oklch(0.985 0 0)"),
            secondary: .oklch("oklch(0.967 0.001 286.375)"), secondaryForeground: .oklch("oklch(0.21 0.006 285.885)"),
            muted: .oklch("oklch(0.967 0.001 286.375)"), mutedForeground: .oklch("oklch(0.552 0.016 285.938)"),
            accent: .oklch("oklch(0.967 0.001 286.375)"), accentForeground: .oklch("oklch(0.21 0.006 285.885)"),
            destructive: .oklch("oklch(0.577 0.245 27.325)"), border: .oklch("oklch(0.92 0.004 286.32)"),
            input: .oklch("oklch(0.92 0.004 286.32)"), ring: .oklch("oklch(0.705 0.015 286.067)"), radius: 10
        ),
        dark: DesignToken(
            background: .oklch("oklch(0.141 0.005 285.823)"), foreground: .oklch("oklch(0.985 0 0)"),
            card: .oklch("oklch(0.21 0.006 285.885)"), cardForeground: .oklch("oklch(0.985 0 0)"),
            popover: .oklch("oklch(0.21 0.006 285.885)"), popoverForeground: .oklch("oklch(0.985 0 0)"),
            primary: .oklch("oklch(0.681 0.162 75.834)"), primaryForeground: .oklch("oklch(0.985 0 0)"),
            secondary: .oklch("oklch(0.274 0.006 286.033)"), secondaryForeground: .oklch("oklch(0.985 0 0)"),
            muted: .oklch("oklch(0.274 0.006 286.033)"), mutedForeground: .oklch("oklch(0.705 0.015 286.067)"),
            accent: .oklch("oklch(0.274 0.006 286.033)"), accentForeground: .oklch("oklch(0.985 0 0)"),
            destructive: .oklch("oklch(0.704 0.191 22.216)"), border: .oklch("oklch(1 0 0 / 10%)"),
            input: .oklch("oklch(1 0 0 / 15%)"), ring: .oklch("oklch(0.552 0.016 285.938)"), radius: 10
        )
    )

    public static let purple = Theme(
        name: "purple",
        light: DesignToken(
            background: .oklch("oklch(1 0 0)"), foreground: .oklch("oklch(0.141 0.005 285.823)"),
            card: .oklch("oklch(1 0 0)"), cardForeground: .oklch("oklch(0.141 0.005 285.823)"),
            popover: .oklch("oklch(1 0 0)"), popoverForeground: .oklch("oklch(0.141 0.005 285.823)"),
            primary: .oklch("oklch(0.558 0.288 302.321)"), primaryForeground: .oklch("oklch(0.971 0.014 303.97)"),
            secondary: .oklch("oklch(0.967 0.001 286.375)"), secondaryForeground: .oklch("oklch(0.21 0.006 285.885)"),
            muted: .oklch("oklch(0.967 0.001 286.375)"), mutedForeground: .oklch("oklch(0.552 0.016 285.938)"),
            accent: .oklch("oklch(0.967 0.001 286.375)"), accentForeground: .oklch("oklch(0.21 0.006 285.885)"),
            destructive: .oklch("oklch(0.577 0.245 27.325)"), border: .oklch("oklch(0.92 0.004 286.32)"),
            input: .oklch("oklch(0.92 0.004 286.32)"), ring: .oklch("oklch(0.705 0.015 286.067)"), radius: 10
        ),
        dark: DesignToken(
            background: .oklch("oklch(0.141 0.005 285.823)"), foreground: .oklch("oklch(0.985 0 0)"),
            card: .oklch("oklch(0.21 0.006 285.885)"), cardForeground: .oklch("oklch(0.985 0 0)"),
            popover: .oklch("oklch(0.21 0.006 285.885)"), popoverForeground: .oklch("oklch(0.985 0 0)"),
            primary: .oklch("oklch(0.457 0.24 302.321)"), primaryForeground: .oklch("oklch(0.971 0.014 303.97)"),
            secondary: .oklch("oklch(0.274 0.006 286.033)"), secondaryForeground: .oklch("oklch(0.985 0 0)"),
            muted: .oklch("oklch(0.274 0.006 286.033)"), mutedForeground: .oklch("oklch(0.705 0.015 286.067)"),
            accent: .oklch("oklch(0.274 0.006 286.033)"), accentForeground: .oklch("oklch(0.985 0 0)"),
            destructive: .oklch("oklch(0.704 0.191 22.216)"), border: .oklch("oklch(1 0 0 / 10%)"),
            input: .oklch("oklch(1 0 0 / 15%)"), ring: .oklch("oklch(0.552 0.016 285.938)"), radius: 10
        )
    )

    public static let teal = Theme(
        name: "teal",
        light: DesignToken(
            background: .oklch("oklch(1 0 0)"), foreground: .oklch("oklch(0.141 0.005 285.823)"),
            card: .oklch("oklch(1 0 0)"), cardForeground: .oklch("oklch(0.141 0.005 285.823)"),
            popover: .oklch("oklch(1 0 0)"), popoverForeground: .oklch("oklch(0.141 0.005 285.823)"),
            primary: .oklch("oklch(0.6 0.118 184.704)"), primaryForeground: .oklch("oklch(0.985 0 0)"),
            secondary: .oklch("oklch(0.967 0.001 286.375)"), secondaryForeground: .oklch("oklch(0.21 0.006 285.885)"),
            muted: .oklch("oklch(0.967 0.001 286.375)"), mutedForeground: .oklch("oklch(0.552 0.016 285.938)"),
            accent: .oklch("oklch(0.967 0.001 286.375)"), accentForeground: .oklch("oklch(0.21 0.006 285.885)"),
            destructive: .oklch("oklch(0.577 0.245 27.325)"), border: .oklch("oklch(0.92 0.004 286.32)"),
            input: .oklch("oklch(0.92 0.004 286.32)"), ring: .oklch("oklch(0.705 0.015 286.067)"), radius: 10
        ),
        dark: DesignToken(
            background: .oklch("oklch(0.141 0.005 285.823)"), foreground: .oklch("oklch(0.985 0 0)"),
            card: .oklch("oklch(0.21 0.006 285.885)"), cardForeground: .oklch("oklch(0.985 0 0)"),
            popover: .oklch("oklch(0.21 0.006 285.885)"), popoverForeground: .oklch("oklch(0.985 0 0)"),
            primary: .oklch("oklch(0.511 0.096 186.391)"), primaryForeground: .oklch("oklch(0.985 0 0)"),
            secondary: .oklch("oklch(0.274 0.006 286.033)"), secondaryForeground: .oklch("oklch(0.985 0 0)"),
            muted: .oklch("oklch(0.274 0.006 286.033)"), mutedForeground: .oklch("oklch(0.705 0.015 286.067)"),
            accent: .oklch("oklch(0.274 0.006 286.033)"), accentForeground: .oklch("oklch(0.985 0 0)"),
            destructive: .oklch("oklch(0.704 0.191 22.216)"), border: .oklch("oklch(1 0 0 / 10%)"),
            input: .oklch("oklch(1 0 0 / 15%)"), ring: .oklch("oklch(0.552 0.016 285.938)"), radius: 10
        )
    )

    public static let indigo = Theme(
        name: "indigo",
        light: DesignToken(
            background: .oklch("oklch(1 0 0)"), foreground: .oklch("oklch(0.141 0.005 285.823)"),
            card: .oklch("oklch(1 0 0)"), cardForeground: .oklch("oklch(0.141 0.005 285.823)"),
            popover: .oklch("oklch(1 0 0)"), popoverForeground: .oklch("oklch(0.141 0.005 285.823)"),
            primary: .oklch("oklch(0.511 0.262 276.966)"), primaryForeground: .oklch("oklch(0.969 0.016 293.756)"),
            secondary: .oklch("oklch(0.967 0.001 286.375)"), secondaryForeground: .oklch("oklch(0.21 0.006 285.885)"),
            muted: .oklch("oklch(0.967 0.001 286.375)"), mutedForeground: .oklch("oklch(0.552 0.016 285.938)"),
            accent: .oklch("oklch(0.967 0.001 286.375)"), accentForeground: .oklch("oklch(0.21 0.006 285.885)"),
            destructive: .oklch("oklch(0.577 0.245 27.325)"), border: .oklch("oklch(0.92 0.004 286.32)"),
            input: .oklch("oklch(0.92 0.004 286.32)"), ring: .oklch("oklch(0.705 0.015 286.067)"), radius: 10
        ),
        dark: DesignToken(
            background: .oklch("oklch(0.141 0.005 285.823)"), foreground: .oklch("oklch(0.985 0 0)"),
            card: .oklch("oklch(0.21 0.006 285.885)"), cardForeground: .oklch("oklch(0.985 0 0)"),
            popover: .oklch("oklch(0.21 0.006 285.885)"), popoverForeground: .oklch("oklch(0.985 0 0)"),
            primary: .oklch("oklch(0.432 0.232 279.738)"), primaryForeground: .oklch("oklch(0.969 0.016 293.756)"),
            secondary: .oklch("oklch(0.274 0.006 286.033)"), secondaryForeground: .oklch("oklch(0.985 0 0)"),
            muted: .oklch("oklch(0.274 0.006 286.033)"), mutedForeground: .oklch("oklch(0.705 0.015 286.067)"),
            accent: .oklch("oklch(0.274 0.006 286.033)"), accentForeground: .oklch("oklch(0.985 0 0)"),
            destructive: .oklch("oklch(0.704 0.191 22.216)"), border: .oklch("oklch(1 0 0 / 10%)"),
            input: .oklch("oklch(1 0 0 / 15%)"), ring: .oklch("oklch(0.552 0.016 285.938)"), radius: 10
        )
    )

    public static let pink = Theme(
        name: "pink",
        light: DesignToken(
            background: .oklch("oklch(1 0 0)"), foreground: .oklch("oklch(0.141 0.005 285.823)"),
            card: .oklch("oklch(1 0 0)"), cardForeground: .oklch("oklch(0.141 0.005 285.823)"),
            popover: .oklch("oklch(1 0 0)"), popoverForeground: .oklch("oklch(0.141 0.005 285.823)"),
            primary: .oklch("oklch(0.592 0.249 0.584)"), primaryForeground: .oklch("oklch(0.969 0.015 12.422)"),
            secondary: .oklch("oklch(0.967 0.001 286.375)"), secondaryForeground: .oklch("oklch(0.21 0.006 285.885)"),
            muted: .oklch("oklch(0.967 0.001 286.375)"), mutedForeground: .oklch("oklch(0.552 0.016 285.938)"),
            accent: .oklch("oklch(0.967 0.001 286.375)"), accentForeground: .oklch("oklch(0.21 0.006 285.885)"),
            destructive: .oklch("oklch(0.577 0.245 27.325)"), border: .oklch("oklch(0.92 0.004 286.32)"),
            input: .oklch("oklch(0.92 0.004 286.32)"), ring: .oklch("oklch(0.705 0.015 286.067)"), radius: 10
        ),
        dark: DesignToken(
            background: .oklch("oklch(0.141 0.005 285.823)"), foreground: .oklch("oklch(0.985 0 0)"),
            card: .oklch("oklch(0.21 0.006 285.885)"), cardForeground: .oklch("oklch(0.985 0 0)"),
            popover: .oklch("oklch(0.21 0.006 285.885)"), popoverForeground: .oklch("oklch(0.985 0 0)"),
            primary: .oklch("oklch(0.487 0.203 358.78)"), primaryForeground: .oklch("oklch(0.969 0.015 12.422)"),
            secondary: .oklch("oklch(0.274 0.006 286.033)"), secondaryForeground: .oklch("oklch(0.985 0 0)"),
            muted: .oklch("oklch(0.274 0.006 286.033)"), mutedForeground: .oklch("oklch(0.705 0.015 286.067)"),
            accent: .oklch("oklch(0.274 0.006 286.033)"), accentForeground: .oklch("oklch(0.985 0 0)"),
            destructive: .oklch("oklch(0.704 0.191 22.216)"), border: .oklch("oklch(1 0 0 / 10%)"),
            input: .oklch("oklch(1 0 0 / 15%)"), ring: .oklch("oklch(0.552 0.016 285.938)"), radius: 10
        )
    )
}

// MARK: - Convenience shorthand

private extension Color {
    static func oklch(_ value: String) -> Color {
        Color(oklchString: value)
    }
}
