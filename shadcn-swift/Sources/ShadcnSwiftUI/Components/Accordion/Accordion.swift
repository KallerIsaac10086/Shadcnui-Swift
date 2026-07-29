import SwiftUI

// MARK: - Accordion

/// A vertically stacked set of interactive headings. Corresponds to `<Accordion>` in shadcn/ui.
public struct Accordion<Content: View>: View {
    public enum AccordionType: Sendable { case single, multiple }

    let type: AccordionType
    @ViewBuilder let content: () -> Content
    @State private var expanded: Set<String> = []

    public init(type: AccordionType = .single, @ViewBuilder content: @escaping () -> Content) {
        self.type = type; self.content = content
    }

    public var body: some View {
        VStack(spacing: 0) { content() }
            .environment(\.accordionExpanded, expanded)
            .environment(\.accordionToggleAction, AccordionToggleAction { value in
                withAnimation(.easeInOut(duration: 0.2)) {
                    if type == .single {
                        expanded = expanded.contains(value) ? [] : [value]
                    } else {
                        if expanded.contains(value) { expanded.remove(value) } else { expanded.insert(value) }
                    }
                }
            })
    }
}

// MARK: - Environment

private struct AccordionExpandedKey: EnvironmentKey { static let defaultValue: Set<String> = [] }
private struct AccordionToggleActionKey: EnvironmentKey {
    static let defaultValue: AccordionToggleAction = AccordionToggleAction { _ in }
}

struct AccordionToggleAction: Sendable {
    let toggle: @Sendable (String) -> Void
}

extension EnvironmentValues {
    var accordionExpanded: Set<String> {
        get { self[AccordionExpandedKey.self] }
        set { self[AccordionExpandedKey.self] = newValue }
    }
    var accordionToggleAction: AccordionToggleAction {
        get { self[AccordionToggleActionKey.self] }
        set { self[AccordionToggleActionKey.self] = newValue }
    }
}

// MARK: - AccordionItem

public struct AccordionItem<Content: View>: View {
    @Environment(\.shadcnToken) private var token
    let value: String
    @ViewBuilder let content: () -> Content

    public init(value: String, @ViewBuilder content: @escaping () -> Content) {
        self.value = value; self.content = content
    }

    public var body: some View {
        VStack(spacing: 0) { content() }
            .overlay(alignment: .bottom) { Rectangle().fill(token.border).frame(height: 1) }
    }
}

// MARK: - AccordionTrigger

public struct AccordionTrigger<Label: View>: View {
    @Environment(\.shadcnToken) private var token
    @Environment(\.accordionExpanded) private var expanded
    @Environment(\.accordionToggleAction) private var toggleAction

    let value: String
    @ViewBuilder let label: () -> Label

    public init(value: String, @ViewBuilder label: @escaping () -> Label) {
        self.value = value; self.label = label
    }
    public init(_ title: String, value: String) where Label == Text {
        self.value = value; self.label = { Text(title) }
    }

    private var isExpanded: Bool { expanded.contains(value) }

    public var body: some View {
        Button { toggleAction.toggle(value) } label: {
            HStack {
                label()
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(token.foreground)
                Spacer()
                Image(systemName: "chevron.down")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(token.mutedForeground)
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    .animation(.easeInOut(duration: 0.2), value: isExpanded)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.borderless)
    }
}

// MARK: - AccordionContent

public struct AccordionContent<Content: View>: View {
    @Environment(\.accordionExpanded) private var expanded
    let value: String
    @ViewBuilder let content: () -> Content

    public init(value: String, @ViewBuilder content: @escaping () -> Content) {
        self.value = value; self.content = content
    }

    public var body: some View {
        if expanded.contains(value) {
            content()
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .transition(.opacity.combined(with: .move(edge: .top)))
        }
    }
}
