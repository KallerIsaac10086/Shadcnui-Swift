import SwiftUI

// MARK: - Drawer

/// A bottom sheet drawer with snap points. Corresponds to `<Drawer>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// @State var show = false
/// Button("Open") { show = true }
///     .drawer(isPresented: $show, snapPoints: [0.3, 0.6, 1.0]) {
///         DrawerContent {
///             DrawerHeader {
///                 DrawerTitle("Title")
///                 DrawerDescription("Description")
///             }
///         }
///     }
/// ```
public struct DrawerModifier<DrawerContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let snapPoints: [CGFloat]
    @ViewBuilder let drawer: () -> DrawerContent

    @State private var dragOffset: CGFloat = 0

    public func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { dismiss() }
                    .transition(.opacity)

                VStack(spacing: 0) {
                    Capsule()
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: 36, height: 5)
                        .padding(.top, 8)
                    drawer()
                        .offset(y: dragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { g in
                                    if g.translation.height > 0 { dragOffset = g.translation.height }
                                }
                                .onEnded { g in
                                    if g.translation.height > 100 { dismiss() }
                                    else { withAnimation { dragOffset = 0 } }
                                }
                        )
                }
                .frame(maxWidth: .infinity)
                .frame(height: screenHeight * (snapPoints.last ?? 0.5))
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isPresented)
    }

    private func dismiss() {
        withAnimation(.easeInOut(duration: 0.2)) { isPresented = false; dragOffset = 0 }
    }

    private var screenHeight: CGFloat {
        #if os(macOS)
        NSScreen.main?.frame.height ?? 800
        #else
        UIScreen.main.bounds.height
        #endif
    }
}

public extension View {
    func drawer<Content: View>(
        isPresented: Binding<Bool>,
        snapPoints: [CGFloat] = [0.5],
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(DrawerModifier(isPresented: isPresented, snapPoints: snapPoints, drawer: content))
    }
}

// MARK: - Drawer Sub-components

public struct DrawerContent<C: View>: View { @ViewBuilder let c: () -> C; public init(@ViewBuilder c: @escaping () -> C) { self.c = c }; public var body: some View { VStack(alignment: .leading, spacing: 8) { c() }.padding(16) } }
public struct DrawerHeader<C: View>: View { @ViewBuilder let c: () -> C; public init(@ViewBuilder c: @escaping () -> C) { self.c = c }; public var body: some View { VStack(spacing: 4) { c() } } }
public struct DrawerTitle: View { let t: String; public init(_ t: String) { self.t = t }; public var body: some View { Text(t).font(.system(size: 18, weight: .semibold)) } }
public struct DrawerDescription: View { let t: String; public init(_ t: String) { self.t = t }; public var body: some View { Text(t).font(.system(size: 14)).foregroundStyle(.secondary) } }
public struct DrawerFooter<C: View>: View { @ViewBuilder let c: () -> C; public init(@ViewBuilder c: @escaping () -> C) { self.c = c }; public var body: some View { HStack(spacing: 8) { c() } } }
