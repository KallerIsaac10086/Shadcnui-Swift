import SwiftUI

// MARK: - Tabs Variant

public enum TabsVariant: String, CaseIterable, Sendable {
    case `default`
    case line
}

// MARK: - Tabs

/// A tabbed interface. Corresponds to `<Tabs>` in shadcn/ui.
public struct Tabs<Content: View>: View {
    @Binding var selection: String
    @ViewBuilder let content: () -> Content

    public init(selection: Binding<String>, @ViewBuilder content: @escaping () -> Content) {
        self._selection = selection
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content()
        }
        .environment(\.tabsSelection, selection)
        .environment(\.tabsSelectAction, TabsSelectAction { selection = $0 })
    }
}

// MARK: - Environment

private struct TabsSelectionKey: EnvironmentKey { static let defaultValue: String = "" }
private struct TabsSelectActionKey: EnvironmentKey {
    static let defaultValue: TabsSelectAction = TabsSelectAction { _ in }
}

struct TabsSelectAction: Sendable {
    let select: @Sendable (String) -> Void
}

extension EnvironmentValues {
    var tabsSelection: String {
        get { self[TabsSelectionKey.self] }
        set { self[TabsSelectionKey.self] = newValue }
    }
    var tabsSelectAction: TabsSelectAction {
        get { self[TabsSelectActionKey.self] }
        set { self[TabsSelectActionKey.self] = newValue }
    }
}

// MARK: - TabsList

public struct TabsList<Content: View>: View {
    @Environment(\.shadcnToken) private var token
    let variant: TabsVariant
    @ViewBuilder let content: () -> Content

    public init(variant: TabsVariant = .default, @ViewBuilder content: @escaping () -> Content) {
        self.variant = variant; self.content = content
    }

    public var body: some View {
        Group {
            switch variant {
            case .default:
                HStack(spacing: 2) { content() }
                    .padding(3)
                    .background(token.muted)
                    .clipShape(RoundedRectangle(cornerRadius: token.radius))
            case .line:
                HStack(spacing: 0) { content() }
                    .overlay(alignment: .bottom) {
                        Rectangle().fill(token.border).frame(height: 1)
                    }
            }
        }
    }
}

// MARK: - TabsTrigger

public struct TabsTrigger: View {
    @Environment(\.shadcnToken) private var token
    @Environment(\.tabsSelection) private var selection
    @Environment(\.tabsSelectAction) private var selectAction

    let value: String
    let label: String
    let variant: TabsVariant
    let icon: Image?

    public init(_ label: String, value: String, variant: TabsVariant = .default, icon: Image? = nil) {
        self.label = label; self.value = value; self.variant = variant; self.icon = icon
    }

    private var isSelected: Bool { selection == value }

    public var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) { selectAction.select(value) }
        } label: {
            HStack(spacing: 6) {
                if let icon { icon.font(.system(size: 14)) }
                Text(label)
            }
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(isSelected ? token.foreground : token.mutedForeground)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background {
                switch variant {
                case .default:
                    if isSelected { token.background.shadow(color: .black.opacity(0.06), radius: 1, y: 1) }
                case .line:
                    Color.clear.overlay(alignment: .bottom) {
                        if isSelected { Rectangle().fill(token.primary).frame(height: 2).padding(.horizontal, 2) }
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: token.radius - 2))
            .contentShape(Rectangle())
        }
        .buttonStyle(.borderless)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - TabsContent

public struct TabsContent<Content: View>: View {
    @Environment(\.tabsSelection) private var selection
    let value: String
    @ViewBuilder let content: () -> Content

    public init(value: String, @ViewBuilder content: @escaping () -> Content) {
        self.value = value; self.content = content
    }

    public var body: some View {
        if selection == value {
            content().padding(.top, 8).transition(.opacity)
        }
    }
}
