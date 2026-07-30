import SwiftUI

// MARK: - Provider

public final class SidebarState: ObservableObject {
    @Published public var isOpen: Bool = true
    @Published public var isCollapsed: Bool = false
    public var expandedWidth: CGFloat = 256
    public var collapsedWidth: CGFloat = 48

    public init(isOpen: Bool = true) { self.isOpen = isOpen }

    public func toggle() { withAnimation(.easeInOut(duration: 0.25)) { isOpen.toggle() } }
    public func toggleCollapse() { withAnimation(.easeInOut(duration: 0.2)) { isCollapsed.toggle() } }
}

// MARK: - Sidebar

/// Collapsible sidebar with `<SidebarProvider>` / `<Sidebar>` / `<SidebarTrigger>`.
///
/// Usage:
/// ```swift
/// @StateObject var sidebar = SidebarState()
///
/// SidebarProvider(state: sidebar) {
///     HStack(spacing: 0) {
///         Sidebar {
///             SidebarHeader { Text("App") }
///             SidebarContent {
///                 SidebarGroup(label: "General") {
///                     SidebarMenuItem(icon: "house", "Home") { }
///                     SidebarMenuItem(icon: "gearshape", "Settings") { }
///                 }
///             }
///             SidebarFooter { Text("v1.0") }
///         }
///         mainContent
///     }
/// }
/// ```
public struct SidebarProvider<Content: View>: View {
    @ObservedObject var state: SidebarState
    @ViewBuilder let content: () -> Content

    public init(state: SidebarState, @ViewBuilder content: @escaping () -> Content) {
        self.state = state; self.content = content
    }

    public var body: some View {
        content().environmentObject(state)
    }
}

public struct Sidebar<Content: View>: View {
    @Environment(\.shadcnToken) private var token
    @EnvironmentObject private var state: SidebarState
    @ViewBuilder let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }

    public var body: some View {
        VStack(spacing: 0) {
            content()
        }
        .frame(width: state.isOpen ? (state.isCollapsed ? state.collapsedWidth : state.expandedWidth) : 0)
        .background(token.card)
        .overlay(alignment: .trailing) {
            Rectangle().fill(token.border).frame(width: 1)
        }
    }
}

// MARK: - Trigger

public struct SidebarTrigger: View {
    @Environment(\.shadcnToken) private var token
    @EnvironmentObject private var state: SidebarState

    public init() {}

    public var body: some View {
        Button { state.toggle() } label: {
            Image(systemName: "sidebar.left")
                .font(.system(size: 16))
                .foregroundColor(token.mutedForeground)
        }
        .buttonStyle(.borderless)
        .help("Toggle sidebar")
    }
}

// MARK: - Sub‑components

public struct SidebarHeader<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View {
        VStack(spacing: 0) { content() }
            .padding(.horizontal, 12).padding(.vertical, 16)
    }
}

public struct SidebarContent<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) { content() }
                .padding(.horizontal, 8)
        }
    }
}

public struct SidebarFooter<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View {
        VStack(spacing: 0) { content() }.padding(.horizontal, 12).padding(.vertical, 12)
    }
}

public struct SidebarGroup<Content: View>: View {
    @Environment(\.shadcnToken) private var token
    @EnvironmentObject private var state: SidebarState

    let label: String
    @ViewBuilder let content: () -> Content

    public init(label: String, @ViewBuilder content: @escaping () -> Content) {
        self.label = label; self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            if state.isOpen && !state.isCollapsed {
                Text(label)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(token.mutedForeground)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
            }
            VStack(spacing: 2) { content() }
        }
        .padding(.bottom, 12)
    }
}

public struct SidebarMenuItem: View {
    @Environment(\.shadcnToken) private var token
    @EnvironmentObject private var state: SidebarState
    @State private var hovered = false

    let icon: String
    let label: String
    let action: () -> Void
    var isActive: Bool = false

    public init(icon: String, _ label: String, isActive: Bool = false, action: @escaping () -> Void) {
        self.icon = icon; self.label = label; self.isActive = isActive; self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .frame(width: 18)
                if state.isOpen && !state.isCollapsed {
                    Text(label)
                        .lineLimit(1)
                    Spacer()
                }
            }
            .font(.system(size: 14))
            .foregroundColor(isActive ? token.accentForeground : token.foreground)
            .padding(.horizontal, state.isCollapsed ? 0 : 10)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(hovered || isActive ? token.accent : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .contentShape(Rectangle())
        }
        .buttonStyle(.borderless)
        .onHover { hovered = $0 }
    }
}

public struct SidebarSeparator: View {
    @Environment(\.shadcnToken) private var token
    public init() {}
    public var body: some View {
        Rectangle().fill(token.border).frame(height: 1).padding(.horizontal, 12).padding(.vertical, 4)
    }
}
