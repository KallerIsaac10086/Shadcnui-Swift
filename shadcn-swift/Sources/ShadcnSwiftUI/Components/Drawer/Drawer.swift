import SwiftUI

// MARK: - Drawer Side

public enum DrawerSide: String, CaseIterable, Sendable {
    case top, bottom, leading, trailing
}

// MARK: - Drawer Modifier

/// A panel that slides in from a screen edge with optional drag-to-dismiss.
/// Corresponds to `<Drawer>` in shadcn/ui.
public struct DrawerModifier<DrawerContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let side: DrawerSide
    let snapPoint: CGFloat
    @ViewBuilder let drawer: () -> DrawerContent

    @State private var dragOffset: CGFloat = 0

    public func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                overlay
                drawerPanel
                    .environment(\.dialogDismissAction, DialogDismissAction(handler: dismiss))
                    .transition(slideTransition)
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

    @ViewBuilder
    private var drawerPanel: some View {
        GeometryReader { geo in
            ZStack(alignment: alignment) {
                drawer()
                    .offset(dragOffsetValue)
                    .gesture(dragGesture(for: geo))
                    .frame(
                        maxWidth: side == .leading || side == .trailing ? 340 : .infinity,
                        maxHeight: side == .top || side == .bottom ? geo.size.height * snapPoint : .infinity,
                        alignment: .topLeading
                    )
            }
        }
    }

    private var alignment: Alignment {
        switch side {
        case .top:      return .top
        case .bottom:   return .bottom
        case .leading:  return .leading
        case .trailing: return .trailing
        }
    }

    private var slideTransition: AnyTransition {
        switch side {
        case .top:      return .move(edge: .top)
        case .bottom:   return .move(edge: .bottom)
        case .leading:  return .move(edge: .leading)
        case .trailing: return .move(edge: .trailing)
        }
    }

    private var dragOffsetValue: CGSize {
        switch side {
        case .top:      return CGSize(width: 0, height: -dragOffset)
        case .bottom:   return CGSize(width: 0, height: dragOffset)
        case .leading:  return CGSize(width: -dragOffset, height: 0)
        case .trailing: return CGSize(width: dragOffset, height: 0)
        }
    }

    private func dragGesture(for geo: GeometryProxy) -> some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { value in
                let delta = dragDelta(from: value.translation)
                dragOffset = max(0, delta)
            }
            .onEnded { value in
                let threshold: CGFloat = 80
                if dragOffset > threshold {
                    dismiss()
                } else {
                    withAnimation(.easeOut(duration: 0.2)) { dragOffset = 0 }
                }
            }
    }

    /// Positive value = dragging toward the screen center (dismiss direction).
    private func dragDelta(from translation: CGSize) -> CGFloat {
        switch side {
        case .top:      return -translation.height
        case .bottom:   return translation.height
        case .leading:  return -translation.width
        case .trailing: return translation.width
        }
    }

    private func dismiss() {
        isPresented = false
        dragOffset = 0
    }
}

public extension View {
    /// Presents a drawer panel from a screen edge.
    func drawer<Content: View>(
        isPresented: Binding<Bool>,
        side: DrawerSide = .bottom,
        snapPoint: CGFloat = 0.5,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(DrawerModifier(isPresented: isPresented, side: side, snapPoint: snapPoint, drawer: content))
    }
}

// MARK: - DrawerContent

/// The drawer panel surface with drag handle and optional close button.
public struct DrawerContent<Content: View>: View {
    @Environment(\.shadcnToken) private var token
    @Environment(\.dialogDismissAction) private var dismissAction

    let side: DrawerSide
    let showCloseButton: Bool
    let showHandle: Bool
    let width: CGFloat
    let height: CGFloat?
    @ViewBuilder let content: () -> Content

    public init(
        side: DrawerSide = .bottom,
        showCloseButton: Bool = false,
        showHandle: Bool = true,
        width: CGFloat = 340,
        height: CGFloat? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.side = side
        self.showCloseButton = showCloseButton
        self.showHandle = showHandle
        self.width = width
        self.height = height
        self.content = content
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Drag handle (only for top/bottom)
            if showHandle, side == .top || side == .bottom {
                Capsule()
                    .fill(token.mutedForeground.opacity(0.4))
                    .frame(width: 36, height: 5)
                    .padding(.top, 8)
                    .padding(.bottom, 4)
            }

            content()
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .padding(.top, (showHandle && (side == .top || side == .bottom)) ? 0 : 20)
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
            if showCloseButton, side == .leading || side == .trailing {
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

// MARK: - DrawerClose

/// A button that dismisses the nearest drawer when tapped.
public struct DrawerClose<Label: View>: View {
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

public struct DrawerHeader<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View { VStack(alignment: .leading, spacing: 6) { content() } }
}

public struct DrawerTitle: View {
    @Environment(\.shadcnToken) private var token
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text).font(.system(size: 18, weight: .semibold)).foregroundColor(token.foreground)
    }
}

public struct DrawerDescription: View {
    @Environment(\.shadcnToken) private var token
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text).font(.system(size: 14)).foregroundColor(token.mutedForeground)
    }
}

public struct DrawerFooter<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View { HStack(spacing: 8) { Spacer(); content() } }
}
