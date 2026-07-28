import SwiftUI

/// Parse an oklch color string like "oklch(0.205 0 0)" into a SwiftUI Color.
///
/// - Format: `oklch(L C H)` or `oklch(L C H / A)`
///   - `L`: lightness, 0..1 (or 0..100% with `%`)
///   - `C`: chroma, >= 0
///   - `H`: hue in degrees, 0..360
///   - `A`: optional alpha, 0..1 (or 0..100% with `%`)
extension Color {

    /// Create a Color from an oklch string (e.g. `"oklch(0.205 0 0)"`).
    init(oklchString: String) {
        guard let parsed = Color.parseOKLCH(oklchString) else {
            self = .black
            return
        }
        self.init(oklchLightness: parsed.l, chroma: parsed.c, hue: parsed.h, opacity: parsed.alpha)
    }

    /// Create a Color from oklch components (L, C, H) with optional alpha.
    init(oklchLightness l: Double, chroma c: Double, hue h: Double, opacity alpha: Double = 1.0) {
        let labL = l
        let labA = c * cos(h * .pi / 180)
        let labB = c * sin(h * .pi / 180)

        let (r, g, b) = Color.oklabToLinearSRGB(l: labL, a: labA, b: labB)

        self.init(
            red: max(0, min(1, r)),
            green: max(0, min(1, g)),
            blue: max(0, min(1, b)),
            opacity: max(0, min(1, alpha))
        )
    }

    // MARK: - Parser

    private static func parseOKLCH(_ string: String) -> (l: Double, c: Double, h: Double, alpha: Double)? {
        // Strip "oklch(" prefix and ")"
        var s = string.trimmingCharacters(in: .whitespaces)
        guard s.hasPrefix("oklch("), s.hasSuffix(")") else { return nil }
        s = String(s.dropFirst(6).dropLast())

        // Split on whitespace; expect 3 or 4 parts
        let parts = s.split(separator: " ").filter { !$0.isEmpty }
        guard parts.count >= 3 else { return nil }

        func parseValue(_ raw: String.SubSequence) -> Double? {
            let str = String(raw)
            if str.hasSuffix("%") {
                return Double(str.dropLast())?.let { $0 / 100.0 }
            }
            // Handle "1 / 10%" patterns (alpha with /)
            if let slashIndex = str.firstIndex(of: "/") {
                let numericPart = String(str[str.startIndex..<slashIndex]).trimmingCharacters(in: .whitespaces)
                let fracPart = String(str[str.index(after: slashIndex)...]).trimmingCharacters(in: .whitespaces)
                if let numerator = Double(numericPart) {
                    if fracPart.hasSuffix("%") {
                        if let d = Double(fracPart.dropLast()) {
                            return numerator / (100.0 / d)
                        }
                    }
                    if let denominator = Double(fracPart), denominator != 0 {
                        return numerator / denominator
                    }
                }
                return nil
            }
            return Double(str)
        }

        guard let l = parseValue(parts[0]),
              let c = parseValue(parts[1]),
              let h = parseValue(parts[2]) else { return nil }

        var alpha: Double = 1.0
        if parts.count >= 4 {
            alpha = parseValue(parts[3]) ?? 1.0
        }

        return (l, c, h, alpha)
    }

    // MARK: - oklab → Linear sRGB conversion

    /// Convert oklab (approximated as L, a, b) to linear sRGB.
    private static func oklabToLinearSRGB(l: Double, a: Double, b: Double) -> (r: Double, g: Double, b: Double) {
        let l_ = l + 0.3963377774 * a + 0.2158037573 * b
        let m_ = l - 0.1055613458 * a - 0.0638541728 * b
        let s_ = l - 0.0894841775 * a - 1.2914855480 * b

        let l3 = pow(l_, 3)
        let m3 = pow(m_, 3)
        let s3 = pow(s_, 3)

        let r = 4.0767416621 * l3 - 3.3077115913 * m3 + 0.2309699292 * s3
        let g = -1.2684380046 * l3 + 2.6097574011 * m3 - 0.3413193965 * s3
        let b = -0.0041960863 * l3 - 0.7034186147 * m3 + 1.7076147010 * s3

        return (r, g, b)
    }
}

// MARK: - Convenience

private extension Double {
    func `let`<T>(_ transform: (Double) -> T) -> T? {
        transform(self)
    }
}

/// Convert a CSS variable value string (e.g. `"oklch(0.205 0 0)"`) directly to Color.
extension Color {
    static func css(_ value: String?) -> Color {
        guard let value else { return .clear }
        return Color(oklchString: value)
    }
}
