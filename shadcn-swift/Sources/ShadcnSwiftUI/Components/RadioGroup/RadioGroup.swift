import SwiftUI

/// Radio group container. Corresponds to `<RadioGroup>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// RadioGroup(selection: $selected) {
///     RadioItem("Option A", value: "a")
///     RadioItem("Option B", value: "b")
/// }
/// ```
public struct RadioGroup<Content: View, Value: Hashable>: View {
    @Binding var selection: Value
    @ViewBuilder let content: () -> Content

    public init(selection: Binding<Value>, @ViewBuilder content: @escaping () -> Content) {
        self._selection = selection
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            content()
        }
        .environment(\.radioGroupSelection, RadioSelection { selection = $0 as! Value })
        .environment(\.radioGroupValue, selection)
    }
}

// MARK: - Radio Helper

struct RadioSelection {
    let select: (AnyHashable) -> Void
}

struct RadioGroupSelectionKey: EnvironmentKey {
    static let defaultValue = RadioSelection(select: { _ in })
}

struct RadioGroupValueKey: EnvironmentKey {
    static let defaultValue: AnyHashable = ""
}

extension EnvironmentValues {
    var radioGroupSelection: RadioSelection {
        get { self[RadioGroupSelectionKey.self] }
        set { self[RadioGroupSelectionKey.self] = newValue }
    }
    var radioGroupValue: AnyHashable {
        get { self[RadioGroupValueKey.self] }
        set { self[RadioGroupValueKey.self] = newValue }
    }
}

// MARK: - Radio Item

/// Individual radio button inside a `RadioGroup`.
public struct RadioItem<Value: Hashable>: View {
    @Environment(\.shadcnToken) private var token
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.radioGroupSelection) private var onSelect
    @Environment(\.radioGroupValue) private var groupValue

    let label: String
    let value: Value

    public init(_ label: String = "", value: Value) {
        self.label = label
        self.value = value
    }

    private var isSelected: Bool { groupValue == value }

    public var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.1)) { onSelect.select(value) }
        } label: {
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(isSelected ? token.primary : Color.clear)
                        .frame(width: 16, height: 16)
                        .overlay(
                            Circle()
                                .strokeBorder(isSelected ? token.primary : token.border, lineWidth: 1)
                        )
                    if isSelected {
                        Circle()
                            .fill(token.primaryForeground)
                            .frame(width: 8, height: 8)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                Text(label).font(.system(size: 14)).foregroundColor(token.foreground)
            }
        }
        .buttonStyle(.plain)
        .opacity(isEnabled ? 1 : 0.5)
    }
}
