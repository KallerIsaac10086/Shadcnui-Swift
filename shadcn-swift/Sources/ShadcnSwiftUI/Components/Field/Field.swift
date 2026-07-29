import SwiftUI

// MARK: - Field

/// A form field with label, description, and error. Corresponds to `<Field>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// Field(isInvalid: showError) {
///     FieldLabel("Email", required: true)
///     Input("Enter email", text: $email)
///     FieldDescription("We'll never share your email.")
///     FieldError("Invalid email address.")
/// }
/// ```
public struct Field<Content: View>: View {
    let isInvalid: Bool
    @ViewBuilder let content: () -> Content

    public init(isInvalid: Bool = false, @ViewBuilder content: @escaping () -> Content) {
        self.isInvalid = isInvalid
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            content()
        }
    }
}

public struct FieldLabel: View {
    @Environment(\.shadcnToken) private var token
    @Environment(\.isEnabled) private var isEnabled

    let text: String
    let required: Bool

    public init(_ text: String, required: Bool = false) {
        self.text = text; self.required = required
    }

    public var body: some View {
        HStack(spacing: 4) {
            Text(text).font(.system(size: 14, weight: .medium)).foregroundColor(token.foreground)
            if required { Text("*").foregroundColor(token.destructive) }
        }
        .opacity(isEnabled ? 1 : 0.5)
    }
}

public struct FieldDescription: View {
    @Environment(\.shadcnToken) private var token
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text).font(.system(size: 12)).foregroundColor(token.mutedForeground)
    }
}

public struct FieldError: View {
    @Environment(\.shadcnToken) private var token
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        if !text.isEmpty {
            Text(text).font(.system(size: 12)).foregroundColor(token.destructive)
        }
    }
}
