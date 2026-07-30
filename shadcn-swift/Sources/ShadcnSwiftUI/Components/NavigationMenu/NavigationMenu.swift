import SwiftUI

// MARK: - Coordinator

private final class NavMenuCoordinator: ObservableObject {
    @Published var openID: UUID?
}

private struct NavMenuIDKey: EnvironmentKey {
    static let defaultValue: UUID = .init()
}
extension EnvironmentValues {
    fileprivate var navMenuID: UUID {
        get { self[NavMenuIDKey.self] }
        set { self[NavMenuIDKey.self] = newValue }
    }
}

// MARK: - NavigationMenu

public struct NavigationMenu<Content: View>: View {
    @StateObject private var coordinator = NavMenuCoordinator()
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View {
        HStack(spacing: 4) { content() }
            .environmentObject(coordinator)
    }
}

public struct NavigationMenuList<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View { HStack(spacing: 4) { content() } }
}

// MARK: - NavigationMenuTrigger

public struct NavigationMenuTrigger: View {
    @Environment(\.shadcnToken) private var token
    @EnvironmentObject private var coordinator: NavMenuCoordinator
    @Environment(\.navMenuID) private var menuID
    @State private var id = UUID()

    let label: String

    public init(_ label: String) { self.label = label }
    private var isOpen: Bool { coordinator.openID == menuID }

    public var body: some View {
        Button {
            withAnimation(.easeOut(duration: 0.15)) {
                coordinator.openID = isOpen ? nil : menuID
            }
        } label: {
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isOpen ? token.accentForeground : token.foreground)
                .padding(.horizontal, 12).padding(.vertical, 8)
                .background(isOpen ? token.accent : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: token.radius))
                .contentShape(Rectangle())
        }
        .buttonStyle(.borderless)
        .environment(\.navMenuID, menuID)
        .anchorPreference(key: PortalAnchorKey.self, value: .bounds) { [menuID: $0] }
    }
}

// MARK: - NavigationMenuContent

public struct NavigationMenuContent<Content: View>: View {
    @Environment(\.shadcnToken) private var token
    @EnvironmentObject private var coordinator: NavMenuCoordinator
    @Environment(\.navMenuID) private var menuID
    @ViewBuilder let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }

    public var body: some View {
        Color.clear
            .onChange(of: coordinator.openID) { _, newValue in
                guard newValue == menuID else {
                    PortalHost.shared.hide(id: menuID)
                    return
                }
                let panel = AnyView(
                    VStack(alignment: .leading, spacing: 0) { content() }
                        .frame(minWidth: 280)
                        .padding(20)
                        .background(token.popover)
                        .clipShape(RoundedRectangle(cornerRadius: token.radius))
                        .overlay(RoundedRectangle(cornerRadius: token.radius).strokeBorder(token.border, lineWidth: 1))
                        .shadow(color: .black.opacity(0.12), radius: 15, y: 8)
                )
                PortalHost.shared.show(id: menuID, content: panel, anchor: .topLeading)
            }
    }
}

// MARK: - NavigationMenuLink

public struct NavigationMenuLink: View {
    @Environment(\.shadcnToken) private var token
    @EnvironmentObject private var coordinator: NavMenuCoordinator
    @State private var hovered = false

    let text: String
    let description: String?
    let action: () -> Void

    public init(_ text: String, description: String? = nil, action: @escaping () -> Void) {
        self.text = text; self.description = description; self.action = action
    }

    public var body: some View {
        Button {
            action()
            coordinator.openID = nil
        } label: {
            VStack(alignment: .leading, spacing: 2) {
                Text(text)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(hovered ? token.accentForeground : token.foreground)
                if let desc = description {
                    Text(desc)
                        .font(.system(size: 13))
                        .foregroundColor(token.mutedForeground)
                        .lineLimit(2)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
            .background(hovered ? token.accent : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .contentShape(Rectangle())
        }
        .buttonStyle(.borderless)
        .onHover { hovered = $0 }
    }
}

// MARK: - NavigationMenuItem (simple link button)

public struct NavigationMenuItem: View {
    @Environment(\.shadcnToken) private var token
    let text: String; let action: () -> Void
    public init(_ text: String, action: @escaping () -> Void) {
        self.text = text; self.action = action
    }
    public var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .padding(.horizontal, 12).padding(.vertical, 8)
                .foregroundColor(token.foreground)
                .clipShape(RoundedRectangle(cornerRadius: token.radius))
        }
        .buttonStyle(.borderless)
    }
}
