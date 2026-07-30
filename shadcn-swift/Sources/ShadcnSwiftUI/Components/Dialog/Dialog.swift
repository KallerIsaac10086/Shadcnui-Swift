import SwiftUI

// MARK: - Dialog Size

public enum DialogSize: Sendable {
    case sm, md, lg, xl, full
}

// MARK: - Dismiss Action

/// Passed down via environment so child views can dismiss the dialog.
struct DialogDismissAction: Sendable {
    let handler: @MainActor @Sendable () -> Void
}

struct DialogDismissKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue = DialogDismissAction { }
}

extension EnvironmentValues {
    var dialogDismissAction: DialogDismissAction {
        get { self[DialogDismissKey.self] }
        set { self[DialogDismissKey.self] = newValue }
    }
}

// MARK: - Dialog Modifier (Global Centered Dialog)

/// A modal dialog centered on screen. Corresponds to `<Dialog>` in shadcn/ui.
public struct DialogOverlayModifier<DialogContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    @ViewBuilder let dialog: () -> DialogContent

    public func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                // Overlay with blur
                overlay
                // Content
                dialog()
                    .environment(\.dialogDismissAction, DialogDismissAction(handler: dismiss))
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .animation(.easeOut(duration: 0.2), value: isPresented)
    }

    @ViewBuilder
    private var overlay: some View {
        Color.black.opacity(0.3)
            .background(.ultraThinMaterial)
            .ignoresSafeArea()
            .onTapGesture { dismiss() }
            .transition(.opacity)
    }

    private func dismiss() {
        isPresented = false
    }
}

public extension View {
    /// Presents a global centered dialog overlay.
    func dialog<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(DialogOverlayModifier(isPresented: isPresented, dialog: content))
    }
}

// MARK: - DialogContent

/// The dialog card. Wraps children in a styled surface with an optional close button.
public struct DialogContent<Content: View>: View {
    @Environment(\.shadcnToken) private var token
    @Environment(\.dialogDismissAction) private var dismissAction

    let size: DialogSize
    let showCloseButton: Bool
    @ViewBuilder let content: () -> Content

    public init(
        size: DialogSize = .md,
        showCloseButton: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.size = size
        self.showCloseButton = showCloseButton
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            content()
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(token.card)
        .foregroundColor(token.cardForeground)
        .clipShape(RoundedRectangle(cornerRadius: token.radius * 1.5))
        .overlay(alignment: .topTrailing) {
            if showCloseButton {
                closeButton
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: token.radius * 1.5)
                .strokeBorder(token.border, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.2), radius: 24, y: 8)
        .frame(maxWidth: maxWidth)
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private var closeButton: some View {
        Button {
            dismissAction.handler()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(token.mutedForeground)
                .frame(width: 24, height: 24)
                .contentShape(Rectangle())
        }
        .buttonStyle(.borderless)
        .padding(12)
    }

    private var maxWidth: CGFloat? {
        switch size {
        case .sm:   return 420
        case .md:   return 540
        case .lg:   return 672
        case .xl:   return 896
        case .full: return nil
        }
    }
}

// MARK: - DialogClose

/// A button that dismisses the nearest dialog when tapped.
/// Place inside a `DialogContent` hierarchy.
public struct DialogClose<Label: View>: View {
    @Environment(\.dialogDismissAction) private var dismissAction
    @ViewBuilder let label: () -> Label

    public init(@ViewBuilder label: @escaping () -> Label) {
        self.label = label
    }

    public var body: some View {
        Button {
            dismissAction.handler()
        } label: {
            label()
        }
    }
}

// MARK: - Sub-components

public struct DialogHeader<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View { VStack(alignment: .leading, spacing: 6) { content() } }
}

public struct DialogTitle: View {
    @Environment(\.shadcnToken) private var token
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text).font(.system(size: 18, weight: .semibold)).foregroundColor(token.foreground)
    }
}

public struct DialogDescription: View {
    @Environment(\.shadcnToken) private var token
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text).font(.system(size: 14)).foregroundColor(token.mutedForeground)
    }
}

public struct DialogFooter<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View { HStack(spacing: 8) { Spacer(); content() } }
}
