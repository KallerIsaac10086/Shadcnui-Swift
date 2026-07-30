import SwiftUI

// MARK: - PopoverModifier

/// Attaches a popover to a trigger view, rendered via Portal for correct z-index.
/// Corresponds to `<Popover>` → `<PopoverTrigger>` + `<PopoverContent>` in shadcn/ui.
public struct PopoverModifier<Panel: View>: ViewModifier {
    @Binding var isPresented: Bool
    @ViewBuilder let panel: () -> Panel
    @State private var portalID = UUID()

    public init(isPresented: Binding<Bool>, @ViewBuilder panel: @escaping () -> Panel) {
        self._isPresented = isPresented
        self.panel = panel
    }

    public func body(content trigger: Content) -> some View {
        trigger
            .anchorPreference(key: PortalAnchorKey.self, value: .bounds) {
                isPresented ? [portalID: $0] : [:]
            }
            .onChange(of: isPresented) { _, presented in
                if presented {
                    PortalHost.shared.show(
                        id: portalID,
                        content: AnyView(PopoverPanel { panel() }),
                        anchor: .topLeading
                    )
                } else {
                    PortalHost.shared.hide(id: portalID)
                }
            }
            .onDisappear { PortalHost.shared.hide(id: portalID) }
    }
}

public extension View {
    func popover<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(PopoverModifier(isPresented: isPresented, panel: content))
    }
}

// MARK: - Internal panel wrapper

private struct PopoverPanel<Content: View>: View {
    @Environment(\.shadcnToken) private var token
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            content()
        }
        .frame(minWidth: 200, maxWidth: 288)
        .padding(16)
        .background(token.popover)
        .clipShape(RoundedRectangle(cornerRadius: token.radius))
        .overlay(
            RoundedRectangle(cornerRadius: token.radius)
                .strokeBorder(token.border, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 8, y: 2)
    }
}

// MARK: - PopoverContent / Header / Title / Description

public struct PopoverContent<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View { content() }
}

public struct PopoverHeader<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) { content() }
    }
}

public struct PopoverTitle: View {
    @Environment(\.shadcnToken) private var token
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text).font(.system(size: 14, weight: .medium)).foregroundColor(token.foreground)
    }
}

public struct PopoverDescription: View {
    @Environment(\.shadcnToken) private var token
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text).font(.system(size: 13)).foregroundColor(token.mutedForeground)
    }
}

public struct PopoverAnchor: View {
    public init() {}
    public var body: some View { Color.clear.frame(width: 0, height: 0) }
}
