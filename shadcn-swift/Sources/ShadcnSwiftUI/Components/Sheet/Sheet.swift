import SwiftUI

// MARK: - Sheet Side

public enum SheetSide: String, CaseIterable, Sendable {
    case top, bottom, leading, trailing
}

// MARK: - Sheet Overlay Modifier

/// A slide-in panel from any screen edge. Corresponds to `<Sheet>` in shadcn/ui.
public struct SheetOverlayModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let side: SheetSide
    @ViewBuilder let sheet: () -> SheetContent

    public func body(content: Content) -> some View {
        content
            .overlay {
                if isPresented {
                    ZStack(alignment: frameAlignment) {
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()
                            .onTapGesture { dismiss() }
                            .transition(.opacity)

                        sheet()
                            .transition(slideTransition)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .animation(.easeInOut(duration: 0.25), value: isPresented)
                }
            }
    }

    private var frameAlignment: Alignment {
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

    private func dismiss() {
        withAnimation(.easeInOut(duration: 0.25)) { isPresented = false }
    }
}

public extension View {
    func sheetOverlay<Content: View>(
        isPresented: Binding<Bool>,
        side: SheetSide = .bottom,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(SheetOverlayModifier(isPresented: isPresented, side: side, sheet: content))
    }
}

// MARK: - SheetContent

public struct SheetContent<Content: View>: View {
    @Environment(\.shadcnToken) private var token

    let side: SheetSide
    @ViewBuilder let content: () -> Content

    public init(
        side: SheetSide = .bottom,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.side = side
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            content()
        }
        .frame(
            maxWidth: side == .leading || side == .trailing ? 340 : .infinity,
            maxHeight: side == .top || side == .bottom ? nil : .infinity,
            alignment: .topLeading
        )
        .padding(20)
        .background(token.card)
        .clipShape(shape)
        .shadow(color: .black.opacity(0.2), radius: 24, y: 8)
    }

    private var shape: some Shape {
        switch side {
        case .top:
            return AnyShape(UnevenRoundedRectangle(bottomLeadingRadius: 16, bottomTrailingRadius: 16))
        case .bottom:
            return AnyShape(UnevenRoundedRectangle(topLeadingRadius: 16, topTrailingRadius: 16))
        case .leading:
            return AnyShape(UnevenRoundedRectangle(bottomTrailingRadius: 16, topTrailingRadius: 16))
        case .trailing:
            return AnyShape(UnevenRoundedRectangle(topLeadingRadius: 16, bottomLeadingRadius: 16))
        }
    }
}

private struct AnyShape: Shape, @unchecked Sendable {
    let _path: @Sendable (CGRect) -> Path
    init<S: Shape>(_ shape: S) { _path = { shape.path(in: $0) } }
    func path(in rect: CGRect) -> Path { _path(rect) }
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
