// shadcn-swift Component Template
// Copy this file into your project to own the component source.
// Pattern mirrors shadcn/ui's "copy source, not install package" philosophy.

import SwiftUI
import ShadcnSwiftUI

// MARK: - Variant Definitions

public enum TemplateVariant: String, CaseIterable, Sendable {
    case `default`
    // case outline
    // case secondary
}

public enum TemplateSize: String, CaseIterable, Sendable {
    case `default`
    // case sm
    // case lg
}

// MARK: - Component View

public struct TemplateComponent<Content: View>: View {
    @Environment(\.shadcnToken) private var token

    let variant: TemplateVariant
    let size: TemplateSize

    // ── First-class params（替换内部默认值，无副作用） ──
    // shadcn/ui equivalent: dedicated props like `size`, `variant`
    let cornerRadius: CGFloat?
    let borderWidth: CGFloat?

    // ── customStyle（外层扩展，相当于 shadcn/ui className） ──
    let customStyle: ((AnyView) -> AnyView)?
    let content: () -> Content

    // MARK: - Init

    public init(
        variant: TemplateVariant = .default,
        size: TemplateSize = .default,
        cornerRadius: CGFloat? = nil,
        borderWidth: CGFloat? = nil,
        customStyle: ((AnyView) -> AnyView)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.variant = variant
        self.size = size
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.customStyle = customStyle
        self.content = content
    }

    // MARK: - Body

    public var body: some View {
        let radius = cornerRadius ?? token.radius
        let border = borderWidth ?? 1

        // 1. 构建内部样式（first-class 参数直接替换默认值）
        let base = AnyView(
            content()
                // Map CSS → SwiftUI:
                // "text-sm"         → .font(.system(size: 14))
                // "bg-primary"      → .background(token.primary)
                // "text-primary-fg" → .foregroundColor(token.primaryForeground)
                // "rounded-md"      → .clipShape(RoundedRectangle(cornerRadius: radius))
                // "border"          → .overlay(roundedRect.strokeBorder(...))
                // "px-4"            → .padding(.horizontal, 16)
                // "py-2"            → .padding(.vertical, 8)
                // "disabled:opacity-50" → @Environment(\.isEnabled)
                // "transition-all"  → .animation(.easeInOut(duration: 0.15))
                .font(font)
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .clipShape(RoundedRectangle(cornerRadius: radius))
                .overlay(
                    RoundedRectangle(cornerRadius: radius)
                        .strokeBorder(token.border, lineWidth: border)
                )
        )

        // 2. customStyle 在外层追加（类似 cn(defaults, className)）
        if let style = customStyle {
            return style(base)
        }
        return base
    }

    // MARK: - Computed Styles

    // Map cva variants → Swift computed properties (switch/case)
    private var font: Font {
        switch size {
        case .default: return .system(size: 14, weight: .medium)
        }
    }

    private var backgroundColor: Color {
        switch variant {
        case .default: return token.primary
        }
    }

    private var foregroundColor: Color {
        switch variant {
        case .default: return token.primaryForeground
        }
    }
}

// MARK: - Convenience Modifier

public extension View {
    func shadcnTemplate(
        variant: TemplateVariant = .default,
        size: TemplateSize = .default,
        cornerRadius: CGFloat? = nil,
        borderWidth: CGFloat? = nil,
        customStyle: ((AnyView) -> AnyView)? = nil
    ) -> some View {
        TemplateComponent(
            variant: variant,
            size: size,
            cornerRadius: cornerRadius,
            borderWidth: borderWidth,
            customStyle: customStyle
        ) { self }
    }
}

// MARK: - Quick Reference

/*
 * ┌─────────────────────────────────────────────────────────────┐
 * │  shadcn/ui → SwiftUI 快速对照                                │
 * ├─────────────────────────────────────────────────────────────┤
 * │  cva variants {}      →  switch/case computed properties    │
 * │  cva defaultVariants  →  init default parameter values      │
 * │  cva compoundVariants →  combined switch or if/else         │
 * │  data-slot            →  (not needed, SwiftUI View = type)  │
 * │  data-variant/size    →  (not needed, captured in init)     │
 * │                                                            │
 * │  ── Customization ──                                       │
 * │  dedicated props (size) → first-class init params           │
 * │  className prop         → customStyle closure               │
 * │  cn(a, b)               → first-class replaces + custom     │
 * │                           wraps (no conflict)               │
 * │                                                            │
 * │  ── Interaction ──                                         │
 * │  asChild / Slot       →  @ViewBuilder label/content param   │
 * │  hover:...            →  #if os(macOS) onHover              │
 * │  disabled:opacity-50  →  @Environment(\.isEnabled)          │
 * │  active:scale-95      →  configuration.isPressed (Button)   │
 * └─────────────────────────────────────────────────────────────┘
 */
