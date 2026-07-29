import SwiftUI

// MARK: - Typography Presets

/// Typography style presets. Corresponds to `<h1>..<h4>`, `<p>`, `<blockquote>`, etc. in shadcn/ui.
///
/// Usage:
/// ```swift
/// Typography.h1("Welcome back")
/// Typography.lead("A modern component library.")
/// Typography.p("This is a paragraph of text.")
/// Typography.code("print(\"hello\")")
/// ```
public enum Typography {
    public static func h1(_ text: String) -> some View {
        Text(text).font(.system(size: 36, weight: .bold)).tracking(-0.5)
    }

    public static func h2(_ text: String) -> some View {
        Text(text).font(.system(size: 28, weight: .semibold)).tracking(-0.3)
    }

    public static func h3(_ text: String) -> some View {
        Text(text).font(.system(size: 22, weight: .semibold))
    }

    public static func h4(_ text: String) -> some View {
        Text(text).font(.system(size: 18, weight: .semibold))
    }

    public static func p(_ text: String) -> some View {
        Text(text).font(.system(size: 16)).lineSpacing(4)
    }

    public static func lead(_ text: String) -> some View {
        Text(text).font(.system(size: 20)).foregroundStyle(.secondary)
    }

    public static func muted(_ text: String) -> some View {
        Text(text).font(.system(size: 14)).foregroundStyle(.secondary)
    }

    public static func code(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 14, design: .monospaced))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color.gray.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }

    public static func blockquote(_ text: String) -> some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 3)
            Text(text)
                .font(.system(size: 16))
                .italic()
                .padding(.leading, 12)
        }
    }
}
