import SwiftUI

// MARK: - Pagination

/// Page navigation. Corresponds to `<Pagination>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// Pagination(currentPage: $page, totalPages: 10)
/// ```
public struct Pagination<Content: View>: View {
    @ViewBuilder let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        HStack(spacing: 4) { content() }
    }
}

// MARK: - PaginationPrevious / Next

public struct PaginationPrevious: View {
    @Environment(\.shadcnToken) private var token
    let action: () -> Void
    let disabled: Bool

    public init(action: @escaping () -> Void, disabled: Bool = false) {
        self.action = action; self.disabled = disabled
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left").font(.system(size: 12, weight: .medium))
                Text("Previous").font(.system(size: 14))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .buttonStyle(.borderless)
        .foregroundColor(token.mutedForeground)
        .disabled(disabled)
        .opacity(disabled ? 0.5 : 1)
    }
}

public struct PaginationNext: View {
    @Environment(\.shadcnToken) private var token
    let action: () -> Void
    let disabled: Bool

    public init(action: @escaping () -> Void, disabled: Bool = false) {
        self.action = action; self.disabled = disabled
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text("Next").font(.system(size: 14))
                Image(systemName: "chevron.right").font(.system(size: 12, weight: .medium))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .buttonStyle(.borderless)
        .foregroundColor(token.mutedForeground)
        .disabled(disabled)
        .opacity(disabled ? 0.5 : 1)
    }
}

// MARK: - PaginationLink

public struct PaginationLink: View {
    @Environment(\.shadcnToken) private var token
    let page: Int
    let isActive: Bool
    let action: () -> Void

    public init(page: Int, isActive: Bool = false, action: @escaping () -> Void) {
        self.page = page; self.isActive = isActive; self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text("\(page)")
                .font(.system(size: 14, weight: .medium))
                .frame(width: 40, height: 40)
        }
        .buttonStyle(.borderless)
        .foregroundColor(isActive ? token.primaryForeground : token.foreground)
        .background(isActive ? token.primary : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: token.radius))
    }
}

// MARK: - PaginationEllipsis

public struct PaginationEllipsis: View {
    @Environment(\.shadcnToken) private var token
    public init() {}
    public var body: some View {
        Text("...")
            .font(.system(size: 14))
            .foregroundColor(token.mutedForeground)
            .frame(width: 40, height: 40)
    }
}
