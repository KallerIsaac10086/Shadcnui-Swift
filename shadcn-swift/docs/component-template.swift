// shadcn-swift Component Template
// Copy this file into your project to own the component source.
// Pattern mirrors shadcn/ui's "copy source, not install package" philosophy.

import SwiftUI
import ShadcnSwiftUI

// MARK: - Variant Definitions

// TODO: Replace with your component's variant enum
public enum TemplateVariant: String, CaseIterable, Sendable {
    case `default`
    // case outline
    // case secondary
}

// TODO: Replace with your component's size enum (if applicable)
public enum TemplateSize: String, CaseIterable, Sendable {
    case `default`
    // case sm
    // case lg
}

// MARK: - Component View

// TODO: Rename `TemplateComponent` to your component name
public struct TemplateComponent<Content: View>: View {
    @Environment(\.shadcnToken) private var token

    let variant: TemplateVariant
    let size: TemplateSize
    let content: () -> Content

    /// Custom style closure — SwiftUI equivalent of shadcn/ui's `className`.
    /// Applied after all defaults, allowing user styles to override.
    let customStyle: ((AnyView) -> AnyView)?

    // MARK: - Init

    public init(
        variant: TemplateVariant = .default,
        size: TemplateSize = .default,
        customStyle: ((AnyView) -> AnyView)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.variant = variant
        self.size = size
        self.content = content
        self.customStyle = customStyle
    }

    // MARK: - Body

    public var body: some View {
        let base = AnyView(
            content()
                // TODO: Map CSS classes → SwiftUI modifiers
                // Example mappings:
                // "text-sm"          → .font(.system(size: 14))
                // "font-semibold"    → .fontWeight(.semibold)
                // "bg-primary"       → .background(token.primary)
                // "text-primary-fg"  → .foregroundColor(token.primaryForeground)
                // "rounded-md"       → .clipShape(RoundedRectangle(cornerRadius: token.radius))
                // "border"           → .overlay(RoundedRectangle(...).strokeBorder(token.border))
                // "px-4"             → .padding(.horizontal, 16)
                // "py-2"             → .padding(.vertical, 8)
                // "shadow-sm"        → .shadow(radius: 2, y: 1)
                // "transition-all"   → .animation(.easeInOut(duration: 0.15), value: ...)
                .font(font)
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        )

        // Apply custom style on top of defaults (like cn(defaults, className))
        if let style = customStyle {
            return style(base)
        }
        return base
    }

    // MARK: - Computed Styles

    // TODO: Map cva variant → SwiftUI computed properties
    // Each variant's CSS classes become a computed property with switch/case.

    private var font: Font {
        switch size {
        case .default: return .system(size: 14, weight: .medium)
        // case .sm:   return .system(size: 13, weight: .medium)
        // case .lg:   return .system(size: 16, weight: .medium)
        }
    }

    private var backgroundColor: Color {
        switch variant {
        case .default: return token.primary
        // case .secondary: return token.secondary
        // case .outline: return .clear
        }
    }

    private var foregroundColor: Color {
        switch variant {
        case .default: return token.primaryForeground
        // case .secondary: return token.secondaryForeground
        // case .outline: return token.foreground
        }
    }

    private var cornerRadius: CGFloat {
        token.radius
    }

    // TODO: Map hover/press states from CSS
    // Web: "hover:bg-primary/90"  →  use @Environment(\.isEnabled)
    // Web: "active:scale-95"      →  use configuration.isPressed (for ButtonStyle)
    //
    // For non-button components, consider:
    // - .onTapGesture for tap feedback
    // - #if os(macOS) + onHover for hover effects
}

// MARK: - Convenience Modifier

// TODO: Provide a View extension for easy application
public extension View {
    func shadcnTemplate(
        variant: TemplateVariant = .default,
        size: TemplateSize = .default,
        customStyle: ((AnyView) -> AnyView)? = nil
    ) -> some View {
        // If your component is a ViewModifier or ButtonStyle, apply it here
        // Otherwise, wrap self in your component View
        TemplateComponent(variant: variant, size: size, customStyle: customStyle) {
            self
        }
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
 * │  className prop       →  customStyle closure                │
 * │  cn(a, b)             →  AnyView(a.modifier(b))             │
 * │  data-slot            →  (not needed, SwiftUI View = type)  │
 * │  data-variant/size    →  (not needed, captured in init)     │
 * │  asChild / Slot       →  @ViewBuilder label/content param   │
 * │  hover:...            →  #if os(macOS) onHover              │
 * │  disabled:opacity-50  →  @Environment(\.isEnabled)          │
 * │  active:scale-95      →  configuration.isPressed (Button)   │
 * └─────────────────────────────────────────────────────────────┘
 */
