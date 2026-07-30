import SwiftUI

// MARK: - Coordinator

/// Coordinates across all menus: only one may be open at a time.
private final class MenubarCoordinator: ObservableObject {
    @Published var openMenuID: UUID?
}

// MARK: - Environment

private struct MenubarMenuIDKey: EnvironmentKey {
    static let defaultValue: UUID = .init()
}

extension EnvironmentValues {
    fileprivate var menubarMenuID: UUID {
        get { self[MenubarMenuIDKey.self] }
        set { self[MenubarMenuIDKey.self] = newValue }
    }
}

// MARK: - MenubarDropdownContainer

/// Styled dropdown wrapper — matches TSX `bg-popover border rounded-md shadow-md`.
public struct MenubarDropdownContainer<Content: View>: View {
    @Environment(\.shadcnToken) private var token
    @ViewBuilder let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            content()
        }
        .frame(minWidth: 192)
        .padding(6)
        .background(token.popover)
        .clipShape(RoundedRectangle(cornerRadius: token.radius))
        .overlay(
            RoundedRectangle(cornerRadius: token.radius)
                .strokeBorder(token.border, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.12), radius: 10, y: 4)
    }
}

// MARK: - Menubar

/// A horizontal menubar for desktop apps.  Corresponds to `<Menubar>` in shadcn/ui.
///
/// Dropdowns are rendered at the view‑tree root via the global `PortalHost`
/// + `PortalRoot` (Radix `<MenubarPortal>` equivalent), so they always render
/// above other content regardless of nesting level.
///
/// Composition:
/// ```swift
/// Menubar {
///     MenubarMenu("File") {
///         MenubarContent {
///             MenubarItem("New", shortcut: "⌘T") { }
///             MenubarSeparator()
///             MenubarItem("Quit", variant: .destructive) { }
///         }
///     }
///     MenubarMenu("Edit") {
///         MenubarContent {
///             MenubarItem("Copy") { }
///         }
///     }
/// }
/// ```
public struct Menubar<Content: View>: View {
    @Environment(\.shadcnToken) private var token
    @StateObject private var coordinator = MenubarCoordinator()
    @ViewBuilder let content: () -> Content
    var externalIsOpen: Binding<Bool>?

    public init(
        isOpen: Binding<Bool>? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.externalIsOpen = isOpen
        self.content = content
    }

    public var body: some View {
        HStack(spacing: 2) { content() }
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: token.radius)
                    .fill(token.card)
            )
            .overlay(
                RoundedRectangle(cornerRadius: token.radius)
                    .strokeBorder(token.border, lineWidth: 1)
            )
            .onChange(of: coordinator.openMenuID) { _, newValue in
                externalIsOpen?.wrappedValue = newValue != nil
            }
            .environmentObject(coordinator)
    }
}

// MARK: - MenubarMenu

/// Each instance gets a stable UUID.  Its `label` drives the trigger button
/// on the bar; the `content` builder (user's `MenubarContent { … }`) is
/// registered in `PortalHost` for root‑level portal rendering.
public struct MenubarMenu<Content: View>: View {
    @State private var id = UUID()
    let label: String
    @ViewBuilder let content: () -> Content

    public init(_ label: String, @ViewBuilder content: @escaping () -> Content) {
        self.label = label
        self.content = content
    }

    public var body: some View {
        MenubarTrigger(label)
            .environment(\.menubarMenuID, id)
        content()
            .environment(\.menubarMenuID, id)
    }
}

// MARK: - MenubarTrigger

/// Standalone trigger for the exact TSX composition.
///
/// ```swift
/// MenubarMenu {
///     MenubarTrigger("File")
///     MenubarContent { … }
/// }
/// ```
public struct MenubarTrigger: View {
    @Environment(\.shadcnToken) private var token
    @EnvironmentObject private var coordinator: MenubarCoordinator
    @Environment(\.menubarMenuID) private var menuID

    let label: String

    public init(_ label: String) { self.label = label }

    private var isOpen: Bool { coordinator.openMenuID == menuID }

    public var body: some View {
        Button {
            withAnimation(.easeOut(duration: 0.15)) {
                coordinator.openMenuID = isOpen ? nil : menuID
            }
        } label: {
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(isOpen ? token.accentForeground : token.foreground)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .frame(height: 28)
                .background(isOpen ? token.accent : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .contentShape(Rectangle())
        }
        .buttonStyle(.borderless)
        .anchorPreference(key: PortalAnchorKey.self, value: .bounds) {
            [menuID: $0]
        }
    }
}

// MARK: - MenubarContent

/// Registers the dropdown panel in `PortalHost` so it renders at the root.
public struct MenubarContent<Content: View>: View {
    @EnvironmentObject private var coordinator: MenubarCoordinator
    @Environment(\.menubarMenuID) private var menuID
    @ViewBuilder let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        Color.clear
            .onChange(of: coordinator.openMenuID) { _, newValue in
                guard newValue == menuID else {
                    PortalHost.shared.hide(id: menuID)
                    return
                }
                let panel = AnyView(
                    MenubarDropdownContainer { content() }
                        .environmentObject(coordinator)
                )
                PortalHost.shared.show(id: menuID, content: panel, anchor: .topLeading)
            }
    }
}

// MARK: - MenubarItem

public struct MenubarItem: View {
    public enum Variant: Sendable { case `default`, destructive }

    @Environment(\.shadcnToken) private var token
    @EnvironmentObject private var coordinator: MenubarCoordinator
    @State private var hovered = false

    let text: String
    let variant: Variant
    let shortcut: String?
    let action: () -> Void

    public init(
        _ text: String,
        variant: Variant = .default,
        shortcut: String? = nil,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.variant = variant
        self.shortcut = shortcut
        self.action = action
    }

    public var body: some View {
        Button {
            action()
            withAnimation(.easeOut(duration: 0.15)) {
                coordinator.openMenuID = nil
            }
        } label: {
            HStack(spacing: 8) {
                Text(text)
                    .font(.system(size: 13))
                    .foregroundColor(
                        variant == .destructive
                            ? token.destructive
                            : (hovered ? token.accentForeground : token.foreground)
                    )

                if let shortcut {
                    Spacer(minLength: 24)
                    Text(shortcut)
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundColor(token.mutedForeground)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(
                hovered
                    ? (variant == .destructive
                        ? token.destructive.opacity(0.12)
                        : token.accent)
                    : Color.clear
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.borderless)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .onHover { hovered = $0 }
    }
}

// MARK: - MenubarShortcut

public struct MenubarShortcut: View {
    @Environment(\.shadcnToken) private var token
    let text: String

    public init(_ text: String) { self.text = text }

    public var body: some View {
        Text(text)
            .font(.system(size: 12, design: .monospaced))
            .foregroundColor(token.mutedForeground)
    }
}

// MARK: - MenubarSeparator

public struct MenubarSeparator: View {
    @Environment(\.shadcnToken) private var token

    public init() {}

    public var body: some View {
        Rectangle()
            .fill(token.border)
            .frame(height: 1)
            .padding(.horizontal, -4)
            .padding(.vertical, 4)
    }
}

// MARK: - MenubarLabel

public struct MenubarLabel: View {
    @Environment(\.shadcnToken) private var token
    let text: String

    public init(_ text: String) { self.text = text }

    public var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(token.mutedForeground)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
    }
}