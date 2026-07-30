import SwiftUI

// MARK: - Sheet Side

public enum SheetSide: String, CaseIterable, Sendable {
    case top, bottom, leading, trailing
}

// MARK: - Sheet Modifier

/// A slide-in panel from any screen edge. Corresponds to `<Sheet>` in shadcn/ui.
public struct SheetOverlayModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let side: SheetSide
    @ViewBuilder let sheet: () -> SheetContent

    public func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                overlay
                sheet()
                    .environment(\.dialogDismissAction, DialogDismissAction(handler: dismiss))
                    .transition(.move(edge: slideEdge))
            }
        }
        .ignoresSafeArea()
        .animation(.easeOut(duration: 0.25), value: isPresented)
    }

    @ViewBuilder
    private var overlay: some View {
        Color.black.opacity(0.3)
            .background(.ultraThinMaterial)
            .ignoresSafeArea()
            .onTapGesture { dismiss() }
            .transition(.opacity)
    }

    private var slideEdge: Edge {
        switch side {
        case .top:      return .top
        case .bottom:   return .bottom
        case .leading:  return .leading
        case .trailing: return .trailing
        }
    }

    private func dismiss() {
        isPresented = false
    }
}

public extension View {
    /// Presents a slide-in panel from a screen edge.
    func sheetOverlay<Content: View>(
        isPresented: Binding<Bool>,
        side: SheetSide = .trailing,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(SheetOverlayModifier(isPresented: isPresented, side: side, sheet: content))
    }
}

// MARK: - SheetContent

/// The sheet panel surface with optional close button.
public struct SheetContent<Content: View>: View {
    @Environment(\.shadcnToken) private var token
    @Environment(\.dialogDismissAction) private var dismissAction

    let side: SheetSide
    let showCloseButton: Bool
    let width: CGFloat
    let height: CGFloat?
    @ViewBuilder let content: () -> Content

    public init(
        side: SheetSide = .trailing,
        showCloseButton: Bool = true,
        width: CGFloat = 340,
        height: CGFloat? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.side = side
        self.showCloseButton = showCloseButton
        self.width = width
        self.height = height
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            content()
        }
        .frame(
            maxWidth: side == .leading || side == .trailing ? width : .infinity,
            maxHeight: side == .top || side == .bottom ? height : .infinity,
            alignment: .topLeading
        )
        .padding(edgeInsets)
        .background(token.card)
        .clipShape(shape)
        .overlay(alignment: .topTrailing) {
            if showCloseButton {
                closeButton
            }
        }
        .shadow(color: .black.opacity(0.2), radius: 24, y: 8)
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

    /// Padding with 0 on the screen-edge side so the panel sits flush.
    private var edgeInsets: EdgeInsets {
        switch side {
        case .top:      return EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20)
        case .bottom:   return EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20)
        case .leading:  return EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 20)
        case .trailing: return EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 0)
        }
    }

    private var shape: UnevenRoundedRectangle {
        switch side {
        case .top:
            return UnevenRoundedRectangle(bottomLeadingRadius: 16, bottomTrailingRadius: 16)
        case .bottom:
            return UnevenRoundedRectangle(topLeadingRadius: 16, topTrailingRadius: 16)
        case .leading:
            return UnevenRoundedRectangle(bottomTrailingRadius: 16, topTrailingRadius: 16)
        case .trailing:
            return UnevenRoundedRectangle(topLeadingRadius: 16, bottomLeadingRadius: 16)
        }
    }
}

// MARK: - SheetClose

/// A button that dismisses the nearest sheet when tapped.
public struct SheetClose<Label: View>: View {
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

public struct SheetHeader<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View { VStack(alignment: .leading, spacing: 6) { content() } }
}

public struct SheetTitle: View {
    @Environment(\.shadcnToken) private var token
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text).font(.system(size: 18, weight: .semibold)).foregroundColor(token.foreground)
    }
}

public struct SheetDescription: View {
    @Environment(\.shadcnToken) private var token
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text).font(.system(size: 14)).foregroundColor(token.mutedForeground)
    }
}

public struct SheetFooter<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View { HStack(spacing: 8) { Spacer(); content() } }
}
