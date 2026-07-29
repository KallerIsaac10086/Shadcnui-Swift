import SwiftUI

// MARK: - Table

/// A basic data table. Corresponds to `<Table>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// Table {
///     TableHeader {
///         TableRow {
///             TableHead("Name")
///             TableHead("Status")
///         }
///     }
///     TableBody {
///         TableRow {
///             TableCell("John").fontWeight(.medium)
///             TableCell("Active")
///         }
///     }
/// }
/// ```
public struct Table<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View {
        VStack(spacing: 0) { content() }
    }
}

public struct TableHeader<Content: View>: View {
    @Environment(\.shadcnToken) private var token
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View {
        VStack(spacing: 0) { content() }
            .overlay(alignment: .bottom) { Rectangle().fill(token.border).frame(height: 1) }
    }
}

public struct TableBody<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View { VStack(spacing: 0) { content() } }
}

public struct TableFooter<Content: View>: View {
    @Environment(\.shadcnToken) private var token
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View {
        VStack(spacing: 0) { content() }
            .background(token.muted.opacity(0.5))
            .overlay(alignment: .top) { Rectangle().fill(token.border).frame(height: 1) }
    }
}

public struct TableRow<Content: View>: View {
    @Environment(\.shadcnToken) private var token
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View {
        HStack(spacing: 0) { content() }
            .overlay(alignment: .bottom) { Rectangle().fill(token.border).frame(height: 1) }
    }
}

public struct TableHead: View {
    @Environment(\.shadcnToken) private var token
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(token.mutedForeground)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
    }
}

public struct TableCell: ViewModifier {
    @Environment(\.shadcnToken) private var token
    public func body(content: Content) -> some View {
        content
            .font(.system(size: 14))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
    }
}

public extension View {
    func tableCell() -> some View {
        modifier(TableCell())
    }
}
