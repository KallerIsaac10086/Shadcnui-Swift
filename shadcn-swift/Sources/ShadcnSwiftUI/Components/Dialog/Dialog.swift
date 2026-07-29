import SwiftUI

// MARK: - Dialog Size

public enum DialogSize: Sendable {
    case sm
    case md
    case lg
    case xl
    case full
}

// MARK: - Dialog

/// A modal dialog. Corresponds to `<Dialog>` in shadcn/ui.
///
/// Presents as a centered overlay with fade + zoom animation.
///
/// Usage:
/// ```swift
/// @State var showDialog = false
///
/// Button("Open") { showDialog = true }
///     .dialog(isPresented: $showDialog) {
///         DialogContent(size: .sm) {
///             DialogHeader {
///                 DialogTitle("Title")
///                 DialogDescription("Description")
///             }
///             DialogFooter {
///                 Button("Cancel") { showDialog = false }
///                     .shadcnButton(variant: .outline)
///                 Button("OK") { showDialog = false }
///                     .shadcnButton()
///             }
///         }
///     }
/// ```
public struct DialogOverlayModifier<DialogContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    @ViewBuilder let dialog: () -> DialogContent

    public func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture { dismiss() }
                    .transition(.opacity)

                dialog()
                    .transition(.scale(scale: 0.95).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.15), value: isPresented)
    }

    private func dismiss() {
        withAnimation(.easeInOut(duration: 0.15)) { isPresented = false }
    }
}

public extension View {
    /// Presents a shadcn-styled dialog overlay.
    func dialog<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(DialogOverlayModifier(isPresented: isPresented, dialog: content))
    }
}

// MARK: - DialogContent

public struct DialogContent<Content: View>: View {
    @Environment(\.shadcnToken) private var token

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
        .frame(maxWidth: maxWidth)
        .padding(24)
        .background(token.card)
        .foregroundColor(token.cardForeground)
        .clipShape(RoundedRectangle(cornerRadius: token.radius * 1.5))
        .overlay(
            RoundedRectangle(cornerRadius: token.radius * 1.5)
                .strokeBorder(token.border, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.15), radius: 16, y: 4)
        .padding(.horizontal, 16)
    }

    private var maxWidth: CGFloat? {
        switch size {
        case .sm:   return 384
        case .md:   return 512
        case .lg:   return 672
        case .xl:   return 896
        case .full: return nil
        }
    }
}

// MARK: - DialogHeader

public struct DialogHeader<Content: View>: View {
    @ViewBuilder let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            content()
        }
    }
}

// MARK: - DialogTitle

public struct DialogTitle: View {
    @Environment(\.shadcnToken) private var token

    let text: String

    public init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        Text(text)
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(token.foreground)
    }
}

// MARK: - DialogDescription

public struct DialogDescription: View {
    @Environment(\.shadcnToken) private var token

    let text: String

    public init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        Text(text)
            .font(.system(size: 14))
            .foregroundColor(token.mutedForeground)
    }
}

// MARK: - DialogFooter

public struct DialogFooter<Content: View>: View {
    @ViewBuilder let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        HStack(spacing: 8) {
            Spacer()
            content()
        }
    }
}
