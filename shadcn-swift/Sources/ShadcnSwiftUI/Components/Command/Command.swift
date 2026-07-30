import SwiftUI

// MARK: - Command

/// A ⌘K command palette. Corresponds to `<Command>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// @State var showCommand = false
/// Button("⌘K") { showCommand = true }
///     .dialog(isPresented: $showCommand) {
///         CommandDialog {
///             CommandInput(placeholder: "Type a command...", text: $search)
///             CommandList {
///                 CommandGroup(heading: "Actions") {
///                     CommandItem("New File") { ... }
///                     CommandItem("Open...") { ... }
///                 }
///             }
///         }
///     }
/// ```
public struct CommandDialog<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View {
        VStack(spacing: 0) { content() }
    }
}

// MARK: - CommandInput

public struct CommandInput: View {
    @Environment(\.shadcnToken) private var token

    let placeholder: String
    @Binding var text: String

    public init(placeholder: String = "Type a command or search...", text: Binding<String>) {
        self.placeholder = placeholder; self._text = text
    }

    public var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(token.mutedForeground)
            TextField(placeholder, text: $text)
                .font(.system(size: 14))
        }
        .padding(12)
        .overlay(alignment: .bottom) { Rectangle().fill(token.border).frame(height: 1) }
    }
}

// MARK: - CommandList

public struct CommandList<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View { VStack(spacing: 0) { content() } }
}

// MARK: - CommandGroup

public struct CommandGroup<Content: View>: View {
    @Environment(\.shadcnToken) private var token

    let heading: String?
    @ViewBuilder let content: () -> Content

    public init(heading: String? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.heading = heading; self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let heading {
                Text(heading)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(token.mutedForeground)
                    .padding(.horizontal, 12)
                    .padding(.top, 8)
                    .padding(.bottom, 4)
            }
            content()
        }
    }
}

// MARK: - CommandItem

public struct CommandItem: View {
    @Environment(\.shadcnToken) private var token

    let text: String
    let shortcut: String?
    let action: () -> Void

    public init(_ text: String, shortcut: String? = nil, action: @escaping () -> Void) {
        self.text = text; self.shortcut = shortcut; self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack {
                Text(text).font(.system(size: 14))
                Spacer()
                if let shortcut {
                    Text(shortcut)
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundColor(token.mutedForeground)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(.borderless)
    }
}

// MARK: - CommandEmpty

public struct CommandEmpty: View {
    @Environment(\.shadcnToken) private var token
    let text: String
    public init(_ text: String = "No results found.") { self.text = text }
    public var body: some View {
        Text(text).font(.system(size: 14)).foregroundColor(token.mutedForeground).padding(12)
    }
}

// MARK: - CommandSeparator

public struct CommandSeparator: View {
    @Environment(\.shadcnToken) private var token
    public init() {}
    public var body: some View { Rectangle().fill(token.border).frame(height: 1).padding(.horizontal, -4) }
}

// MARK: - CommandShortcut

public struct CommandShortcut: View {
    @Environment(\.shadcnToken) private var token
    let key: String
    public init(_ key: String) { self.key = key }
    public var body: some View {
        Text(key).font(.system(size: 12, design: .monospaced)).foregroundColor(token.mutedForeground)
    }
}
