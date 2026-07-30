import SwiftUI

/// Form field wrapper.  Corresponds to `<FormItem>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// FormField(label: "Email", error: emailError) {
///     TextField("email", text: $email)
/// }
/// ```
public struct FormField<Control: View>: View {
    @Environment(\.shadcnToken) private var token

    @ViewBuilder let label: () -> AnyView
    @ViewBuilder let control: () -> Control
    let message: String?
    let description: String?
    let hasError: Bool

    public init(
        _ text: String = "",
        @ViewBuilder control: @escaping () -> Control
    ) {
        self.label = { AnyView(FormLabel(text)) }
        self.control = control
        self.message = nil
        self.description = nil
        self.hasError = false
    }

    private init(
        label: @escaping () -> AnyView,
        control: @escaping () -> Control,
        message: String?,
        description: String?,
        hasError: Bool
    ) {
        self.label = label
        self.control = control
        self.message = message
        self.description = description
        self.hasError = hasError
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            label()
            control()
            if hasError, let msg = message, !msg.isEmpty {
                Text(msg).font(.system(size: 13)).foregroundColor(token.destructive)
            } else if let desc = description, !desc.isEmpty {
                Text(desc).font(.system(size: 13)).foregroundColor(token.mutedForeground)
            }
        }
    }

    public func formMessage(_ text: String) -> FormField {
        FormField(label: label, control: control, message: text, description: description, hasError: true)
    }

    public func formDescription(_ text: String) -> FormField {
        FormField(label: label, control: control, message: message, description: text, hasError: hasError)
    }
}

// MARK: - Sub‑components

public struct FormLabel: View {
    @Environment(\.shadcnToken) private var token
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text).font(.system(size: 14, weight: .medium)).foregroundColor(token.foreground)
    }
}

public struct FormControl<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View { content() }
}

public struct FormMessage: View {
    @Environment(\.shadcnToken) private var token
    let text: String?
    public init(_ text: String?) { self.text = text }
    public var body: some View {
        if let text, !text.isEmpty {
            Text(text).font(.system(size: 13)).foregroundColor(token.destructive)
        }
    }
}

public struct FormDescription: View {
    @Environment(\.shadcnToken) private var token
    let text: String?
    public init(_ text: String?) { self.text = text }
    public var body: some View {
        if let text, !text.isEmpty {
            Text(text).font(.system(size: 13)).foregroundColor(token.mutedForeground)
        }
    }
}
