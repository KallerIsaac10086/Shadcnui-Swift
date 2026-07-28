import Testing
import SwiftUI
@testable import ShadcnSwift

struct ColorOKLCHTests {

    @Test("Parse neutral theme black/white colors")
    func parseNeutralBase() {
        // Light
        let bg = Color(oklchString: "oklch(1 0 0)")
        #expect(bg != nil)

        let fg = Color(oklchString: "oklch(0.145 0 0)")
        #expect(fg != nil)

        // Dark
        let darkBg = Color(oklchString: "oklch(0.145 0 0)")
        #expect(darkBg != nil)
    }

    @Test("Parse colors with chroma and hue")
    func parseChromatic() {
        let blue = Color(oklchString: "oklch(0.488 0.243 264.376)")
        #expect(blue != nil)

        let red = Color(oklchString: "oklch(0.577 0.245 27.325)")
        #expect(red != nil)
    }

    @Test("Parse colors with alpha slash notation")
    func parseAlpha() {
        let border = Color(oklchString: "oklch(1 0 0 / 10%)")
        #expect(border != nil)

        let input = Color(oklchString: "oklch(1 0 0 / 15%)")
        #expect(input != nil)
    }

    @Test("Parse invalid strings gracefully")
    func parseInvalid() {
        let invalid1 = Color(oklchString: "not-a-color")
        // Should not crash, falls back to black
        #expect(invalid1 != nil)

        let empty = Color(oklchString: "")
        #expect(empty != nil)
    }

    @Test("Theme token resolution")
    func themeTokens() {
        let theme = Themes.neutral
        let light = theme.token(for: .light)
        let dark = theme.token(for: .dark)

        #expect(light.background != dark.background)
        #expect(light.radius == dark.radius)
    }
}
