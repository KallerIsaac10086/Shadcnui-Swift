import SwiftUI

// MARK: - Dialog Size

public enum DialogSize: Sendable {
    case sm, md, lg, xl, full
}

// MARK: - Dialog Modifier

/// A modal dialog. Corresponds to `<Dialog>` in shadcn/ui.
public struct DialogOverlayModifier<DialogContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    @ViewBuilder let dialog: () -> DialogContent

    public func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented) {
                ZStack {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture { dismiss() }
                        .transition(.opacity)

                    dialog()
                        .transition(.scale(scale: 0.95).combined(with: .opacity))
                }
                .animation(.easeInOut(duration: 0.2), value: isPresented)
                .presentationBackground(.clear)
            }
    }

    private func dismiss() {
        withAnimation(.easeInOut(duration: 0.2)) { isPresented = false }
    }
}

public extension View {
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
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(token.card)
        .foregroundColor(token.cardForeground)
        .clipShape(RoundedRectangle(cornerRadius: token.radius * 1.5))
        .overlay(
            RoundedRectangle(cornerRadius: token.radius * 1.5)
                .strokeBorder(token.border, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.2), radius: 24, y: 8)
        .padding(.horizontal, 20)
        .frame(maxWidth: maxWidth)
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
