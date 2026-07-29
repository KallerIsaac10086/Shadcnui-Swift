import SwiftUI

// MARK: - Breadcrumb

/// A breadcrumb navigation trail. Corresponds to `<Breadcrumb>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// Breadcrumb {
///     BreadcrumbItem { BreadcrumbLink("Home") }
///     BreadcrumbSeparator()
///     BreadcrumbItem { BreadcrumbLink("Products") }
///     BreadcrumbSeparator()
///     BreadcrumbItem { BreadcrumbPage("Current") }
/// }
/// ```
public struct Breadcrumb<Content: View>: View {
    @ViewBuilder let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        HStack(spacing: 6) {
            content()
        }
    }
}

// MARK: - BreadcrumbItem

public struct BreadcrumbItem<Content: View>: View {
    @ViewBuilder let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        content()
    }
}

// MARK: - BreadcrumbLink

public struct BreadcrumbLink: View {
    @Environment(\.shadcnToken) private var token

    let label: String

    public init(_ label: String) {
        self.label = label
    }

    public var body: some View {
        Text(label)
            .font(.system(size: 14))
            .foregroundColor(token.mutedForeground)
    }
}

// MARK: - BreadcrumbPage

public struct BreadcrumbPage: View {
    @Environment(\.shadcnToken) private var token

    let label: String

    public init(_ label: String) {
        self.label = label
    }

    public var body: some View {
        Text(label)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(token.foreground)
    }
}

// MARK: - BreadcrumbSeparator

public struct BreadcrumbSeparator: View {
    @Environment(\.shadcnToken) private var token

    public init() {}

    public var body: some View {
        Text("/")
            .font(.system(size: 12))
            .foregroundColor(token.mutedForeground)
    }
}

// MARK: - BreadcrumbEllipsis

public struct BreadcrumbEllipsis: View {
    @Environment(\.shadcnToken) private var token

    public init() {}

    public var body: some View {
        Text("...")
            .font(.system(size: 14))
            .foregroundColor(token.mutedForeground)
    }
}
