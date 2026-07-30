import SwiftUI

// MARK: - Environment

private struct ComboboxMenuIDKey: EnvironmentKey {
    static let defaultValue: UUID = .init()
}

extension EnvironmentValues {
    fileprivate var comboboxMenuID: UUID {
        get { self[ComboboxMenuIDKey.self] }
        set { self[ComboboxMenuIDKey.self] = newValue }
    }
}

// MARK: - Combobox

/// A searchable combobox with dropdown suggestions.
///
/// Matches the TSX composition:
/// ```swift
/// Combobox {
///     ComboboxTrigger("Select…", selection: $selection)
///     ComboboxContent {
///         CommandInput(placeholder: "Search…", text: $search)
///         CommandList {
///             ForEach(items) { item in
///                 ComboboxItem(item.label, value: item.value, selection: $selection)
///             }
///         }
///     }
/// }
/// ```
///
/// The dropdown is rendered at the root of the view tree via the global
/// `PortalHost` + `PortalRoot` (Radix `<ComboboxPrimitive.Portal>` equivalent),
/// so it always renders above other content, regardless of nesting level.
public struct Combobox<Content: View>: View {
    @StateObject private var coordinator = ComboboxCoordinator()
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
        ZStack(alignment: .topLeading) {
            content()
            Color.clear
        }
        .onChange(of: coordinator.openID) { _, newValue in
            externalIsOpen?.wrappedValue = newValue != nil
        }
        .environmentObject(coordinator)
    }
}

// MARK: - Coordinator

/// Local state for one Combobox instance.  ComboboxTrigger writes its
/// `openID` here; ComboboxContent registers its panel in `PortalHost`.
private final class ComboboxCoordinator: ObservableObject {
    @Published var openID: UUID?
}

// MARK: - ComboboxMenu

/// Convenience wrapper that pairs a trigger and content under a stable ID.
public struct ComboboxMenu<Content: View>: View {
    @State private var id = UUID()
    let placeholder: String
    @Binding var selection: String?
    @Binding var query: String
    @ViewBuilder let content: () -> Content

    public init(
        _ placeholder: String,
        selection: Binding<String?>,
        query: Binding<String>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.placeholder = placeholder
        self._selection = selection
        self._query = query
        self.content = content
    }

    public var body: some View {
        ComboboxTrigger(placeholder, selection: $selection)
            .environment(\.comboboxMenuID, id)
        ComboboxContent {
            CommandInput(placeholder: "Search…", text: $query)
            CommandList {
                CommandEmpty("No results found.")
                content()
            }
        }
        .environment(\.comboboxMenuID, id)
    }
}

// MARK: - ComboboxTrigger

/// A trigger button styled like `variant="outline"` that opens the dropdown.
public struct ComboboxTrigger: View {
    @Environment(\.shadcnToken) private var token
    @EnvironmentObject private var coordinator: ComboboxCoordinator
    @Environment(\.comboboxMenuID) private var menuID

    let placeholder: String
    @Binding var selection: String?

    public init(
        _ placeholder: String,
        selection: Binding<String?>
    ) {
        self.placeholder = placeholder
        self._selection = selection
    }

    private var isOpen: Bool { coordinator.openID == menuID }

    public var body: some View {
        Button {
            withAnimation(.easeOut(duration: 0.15)) {
                coordinator.openID = isOpen ? nil : menuID
            }
        } label: {
            HStack(spacing: 8) {
                Text(selection ?? placeholder)
                    .font(.system(size: 14))
                    .foregroundColor(selection != nil ? token.foreground : token.mutedForeground)
                    .lineLimit(1)

                Spacer(minLength: 0)

                Image(systemName: "chevron.up.chevron.down")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(token.mutedForeground)
                    .opacity(0.6)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 36)
            .padding(.horizontal, 12)
            .background(token.background)
            .clipShape(RoundedRectangle(cornerRadius: token.radius))
            .overlay(
                RoundedRectangle(cornerRadius: token.radius)
                    .strokeBorder(token.input, lineWidth: 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.borderless)
        .anchorPreference(key: PortalAnchorKey.self, value: .bounds) {
            [menuID: $0]
        }
    }
}

// MARK: - ComboboxContent

/// Registers the dropdown panel in the global `PortalHost` so it can be
/// rendered at the root level (above all other content).
public struct ComboboxContent<Content: View>: View {
    @Environment(\.shadcnToken) private var token
    @EnvironmentObject private var coordinator: ComboboxCoordinator
    @Environment(\.comboboxMenuID) private var menuID
    @ViewBuilder let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        Color.clear
            .onChange(of: coordinator.openID) { _, newValue in
                guard newValue == menuID else {
                    PortalHost.shared.hide(id: menuID)
                    return
                }
                // Inject the local coordinator back into the AnyView so
                // ComboboxItem etc. can still access it via @EnvironmentObject.
                let panel = AnyView(
                    VStack(spacing: 0) { content() }
                        .environmentObject(coordinator)
                        .frame(minWidth: 200)
                        .background(token.popover)
                        .clipShape(RoundedRectangle(cornerRadius: token.radius))
                        .overlay(
                            RoundedRectangle(cornerRadius: token.radius)
                                .strokeBorder(token.border, lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.12), radius: 10, y: 4)
                )
                PortalHost.shared.show(id: menuID, content: panel)
            }
    }
}

// MARK: - ComboboxItem

public struct ComboboxItem: View {
    @Environment(\.shadcnToken) private var token
    @EnvironmentObject private var coordinator: ComboboxCoordinator
    @State private var hovered = false

    let text: String
    let value: String
    @Binding var selection: String?
    let action: () -> Void

    private var isSelected: Bool { selection == value }

    public init(
        _ text: String,
        value: String,
        selection: Binding<String?>,
        action: @escaping () -> Void = {}
    ) {
        self.text = text
        self.value = value
        self._selection = selection
        self.action = action
    }

    public var body: some View {
        Button {
            selection = value
            action()
            withAnimation(.easeOut(duration: 0.15)) {
                coordinator.openID = nil
            }
        } label: {
            HStack(spacing: 8) {
                Text(text)
                    .font(.system(size: 14))
                    .foregroundColor(hovered ? token.accentForeground : token.foreground)

                Spacer(minLength: 0)

                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(token.primary)
                    .opacity(isSelected ? 1 : 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            .background(hovered ? token.accent : Color.clear)
            .contentShape(Rectangle())
        }
        .buttonStyle(.borderless)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .onHover { hovered = $0 }
    }
}