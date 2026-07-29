import SwiftUI

// MARK: - Accordion

/// A vertically stacked set of interactive headings. Corresponds to `<Accordion>` in shadcn/ui.
///
/// Supports single and multiple expansion modes.
///
/// Usage:
/// ```swift
/// Accordion(type: .single) {
///     AccordionItem(value: "1") {
///         AccordionTrigger("Is it accessible?")
///         AccordionContent { Text("Yes. It adheres to WAI-ARIA patterns.") }
///     }
///     AccordionItem(value: "2") {
///         AccordionTrigger("Is it styled?")
///         AccordionContent { Text("Yes. Fully themeable.") }
///     }
/// }
/// ```
public struct Accordion<Content: View>: View {
    public enum AccordionType: Sendable { case single, multiple }

    let type: AccordionType
    @ViewBuilder let content: () -> Content
    @State private var expanded: Set<String> = []

    public init(type: AccordionType = .single, @ViewBuilder content: @escaping () -> Content) {
        self.type = type
        self.content = content
    }

    public var body: some View {
        VStack(spacing: 0) {
            content()
        }
        .environment(\.accordionExpanded, expanded)
        .environment(\.accordionType, type)
        .onPreferenceChange(AccordionToggleKey.self) { value in
            withAnimation(.easeInOut(duration: 0.2)) {
                if type == .single {
                    expanded = expanded.contains(value) ? [] : [value]
                } else {
                    if expanded.contains(value) { expanded.remove(value) }
                    else { expanded.insert(value) }
                }
            }
        }
    }
}

// MARK: - Environment

private struct AccordionExpandedKey: EnvironmentKey { static let defaultValue: Set<String> = [] }
private struct AccordionTypeKey: EnvironmentKey { static let defaultValue: Accordion.AccordionType = .single }

extension EnvironmentValues {
    var accordionExpanded: Set<String> {
        get { self[AccordionExpandedKey.self] }
        set { self[AccordionExpandedKey.self] = newValue }
    }
    var accordionType: Accordion.AccordionType {
        get { self[AccordionTypeKey.self] }
        set { self[AccordionTypeKey.self] = newValue }
    }
}

struct AccordionToggleKey: PreferenceKey {
    static var defaultValue: String = ""
    static func reduce(value: inout String, nextValue: () -> String) { value = nextValue() }
}

// MARK: - AccordionItem

public struct AccordionItem<Content: View>: View {
    @Environment(\.shadcnToken) private var token
    @Environment(\.accordionExpanded) private var expanded

    let value: String
    @ViewBuilder let content: () -> Content

    public init(value: String, @ViewBuilder content: @escaping () -> Content) {
        self.value = value; self.content = content
    }

    public var body: some View {
        VStack(spacing: 0) {
            content()
        }
        .overlay(alignment: .bottom) {
            Rectangle().fill(token.border).frame(height: 1)
        }
    }
}

// MARK: - AccordionTrigger

public struct AccordionTrigger<Label: View>: View {
    @Environment(\.shadcnToken) private var token
    @Environment(\.accordionExpanded) private var expanded

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
        Button {
            let _ = isExpanded // read for animation trigger
        } label: {
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
        .preference(key: AccordionToggleKey.self, value: value)
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

    private var isExpanded: Bool { expanded.contains(value) }

    public var body: some View {
        if isExpanded {
            content()
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .transition(.opacity.combined(with: .move(edge: .top)))
        }
    }
}
