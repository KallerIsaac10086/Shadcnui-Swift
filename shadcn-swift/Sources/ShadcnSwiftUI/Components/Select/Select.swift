import SwiftUI

// MARK: - Environment Keys

/// Action dispatched when a SelectItem is tapped.
struct SelectAction: Sendable {
    let handler: @Sendable (AnyHashable) -> Void
}

private struct SelectActionKey: EnvironmentKey {
    static let defaultValue = SelectAction { _ in }
}

private struct SelectValueKey: EnvironmentKey {
    static let defaultValue: AnyHashable = ""
}

extension EnvironmentValues {
    var selectAction: SelectAction {
        get { self[SelectActionKey.self] }
        set { self[SelectActionKey.self] = newValue }
    }
    var selectValue: AnyHashable {
        get { self[SelectValueKey.self] }
        set { self[SelectValueKey.self] = newValue }
    }
}

// MARK: - Select

/// A custom-styled dropdown select. Corresponds to `<Select>` in shadcn/ui.
///
/// Uses `fullScreenCover` so the dropdown list is never clipped by parent containers.
/// No GeometryReader / PreferenceKey — avoids "bound preference updated multiple
/// times per frame" warnings.
///
/// ```swift
/// @State var selection = "light"
/// Select(placeholder: "Theme", selection: $selection) {
///     SelectItem("Light", value: "light")
///     SelectItem("Dark", value: "dark")
///     SelectItem("System", value: "system")
/// }
/// ```
public struct Select<Value: Hashable & Sendable, Content: View>: View {
    @Environment(\.shadcnToken) private var token

    let placeholder: String
    @Binding var selection: Value
    @ViewBuilder let content: () -> Content
    @State private var isOpen = false

    public init(
        placeholder: String = "",
        selection: Binding<Value>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.placeholder = placeholder
        self._selection = selection
        self.content = content
    }

    public var body: some View {
        Button {
            isOpen = true
        } label: {
            HStack(spacing: 8) {
                Text(String(describing: selection))
                    .font(.system(size: 14))
                    .lineLimit(1)
                Spacer(minLength: 4)
                Image(systemName: "chevron.down")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(token.mutedForeground)
            }
            .frame(height: 36)
            .padding(.horizontal, 12)
            .background(token.card)
            .foregroundStyle(token.foreground)
            .clipShape(RoundedRectangle(cornerRadius: token.radius))
            .overlay(
                RoundedRectangle(cornerRadius: token.radius)
                    .strokeBorder(token.border, lineWidth: 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.borderless)
        .fullScreenCover(isPresented: $isOpen) {
            SelectOverlay(
                selection: $selection,
                isPresented: $isOpen,
                content: content
            )
            .presentationBackground(.clear)
        }
    }
}

// MARK: - Select Overlay

/// Full-screen transparent overlay that hosts the dropdown list.
private struct SelectOverlay<Value: Hashable & Sendable, Content: View>: View {
    @Environment(\.shadcnToken) private var token

    @Binding var selection: Value
    @Binding var isPresented: Bool
    @ViewBuilder let content: () -> Content

    var body: some View {
        ZStack {
            // Dimmed backdrop — tap anywhere to dismiss
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        isPresented = false
                    }
                }

            // Options card
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        content()
                    }
                }
                .frame(maxHeight: 280)
            }
            .background(token.card)
            .clipShape(RoundedRectangle(cornerRadius: token.radius * 1.5))
            .overlay(
                RoundedRectangle(cornerRadius: token.radius * 1.5)
                    .strokeBorder(token.border, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.15), radius: 16, y: 8)
            .padding(.horizontal, 24)
        }
        .environment(\.selectAction, SelectAction { value in
            if let v = value as? Value {
                selection = v
                isPresented = false
            }
        })
        .environment(\.selectValue, AnyHashable(selection))
    }
}

// MARK: - SelectItem

/// A selectable option inside a `Select` dropdown.
public struct SelectItem<Value: Hashable & Sendable>: View {
    @Environment(\.shadcnToken) private var token
    @Environment(\.selectAction) private var action
    @Environment(\.selectValue) private var currentValue

    let label: String
    let value: Value

    public init(_ label: String, value: Value) {
        self.label = label
        self.value = value
    }

    private var isSelected: Bool {
        currentValue == AnyHashable(value)
    }

    public var body: some View {
        Button {
            action.handler(value)
        } label: {
            HStack(spacing: 10) {
                Text(label)
                    .font(.system(size: 14))
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(token.primary)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(isSelected ? token.muted : Color.clear)
            .contentShape(Rectangle())
        }
        .buttonStyle(.borderless)
    }
}

// MARK: - SelectGroup / SelectLabel / SelectSeparator

/// Groups select items together (no visual separator).
public struct SelectGroup<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View { VStack(alignment: .leading, spacing: 0) { content() } }
}

/// A section heading inside a select dropdown.
public struct SelectLabel: View {
    @Environment(\.shadcnToken) private var token
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(token.mutedForeground)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
    }
}

/// A horizontal divider inside a select dropdown.
public struct SelectSeparator: View {
    @Environment(\.shadcnToken) private var token
    public init() {}
    public var body: some View {
        Rectangle().fill(token.border).frame(height: 1)
    }
}
