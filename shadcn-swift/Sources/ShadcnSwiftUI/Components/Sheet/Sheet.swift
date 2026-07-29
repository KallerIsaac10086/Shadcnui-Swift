import SwiftUI

// MARK: - Sheet Side

public enum SheetSide: String, CaseIterable, Sendable {
    case top
    case bottom
    case leading
    case trailing
}

// MARK: - Sheet Overlay Modifier

/// A slide-in panel from any screen edge. Corresponds to `<Sheet>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// @State var show = false
/// Button("Open") { show = true }
///     .sheetOverlay(isPresented: $show, side: .bottom) {
///         SheetContent {
///             SheetHeader {
///                 SheetTitle("Title")
///                 SheetDescription("Description")
///             }
///         }
///     }
/// ```
public struct SheetOverlayModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let side: SheetSide
    @ViewBuilder let sheet: () -> SheetContent

    public func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture { dismiss() }
                    .transition(.opacity)

                sheet()
                    .transition(slideTransition)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isPresented)
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
        withAnimation(.easeInOut(duration: 0.2)) { isPresented = false }
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
            maxWidth: side == .leading || side == .trailing ? 320 : .infinity,
            maxHeight: side == .top || side == .bottom ? nil : .infinity,
            alignment: sideAlignment
        )
        .padding(20)
        .background(token.card)
        .clipShape(shape)
        .shadow(color: .black.opacity(0.15), radius: 16, y: 4)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: frameAlignment
        )
    }

    private var sideAlignment: Alignment {
        switch side {
        case .top, .bottom: return .topLeading
        case .leading: return .topLeading
        case .trailing: return .topTrailing
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

    private var shape: some Shape {
        switch side {
        case .top:
            return AnyShape(UnevenRoundedRectangle(
                bottomLeadingRadius: token.radius * 1.5,
                bottomTrailingRadius: token.radius * 1.5
            ))
        case .bottom:
            return AnyShape(UnevenRoundedRectangle(
                topLeadingRadius: token.radius * 1.5,
                topTrailingRadius: token.radius * 1.5
            ))
        case .leading:
            return AnyShape(UnevenRoundedRectangle(
                bottomTrailingRadius: token.radius * 1.5,
                topTrailingRadius: token.radius * 1.5
            ))
        case .trailing:
            return AnyShape(UnevenRoundedRectangle(
                topLeadingRadius: token.radius * 1.5,
                bottomLeadingRadius: token.radius * 1.5
            ))
        }
    }
}

private struct AnyShape: Shape, @unchecked Sendable {
    let _path: @Sendable (CGRect) -> Path
    init<S: Shape>(_ shape: S) { _path = { shape.path(in: $0) } }
    func path(in rect: CGRect) -> Path { _path(rect) }
}

// MARK: - Sheet Sub-components

public struct SheetHeader<Content: View>: View {
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
