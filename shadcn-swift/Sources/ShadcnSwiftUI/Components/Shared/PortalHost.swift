import SwiftUI

/// Global singleton that floating components (Combobox, Menubar) write to when
/// their dropdown is active.  A single `overlayPreferenceValue` attached to the
/// **root ScrollView** reads from here and renders all portal panels on top of
/// everything — Radix `<Portal>` equivalent.
public final class PortalHost: ObservableObject, @unchecked Sendable {
    public static let shared = PortalHost()

    @Published public var activeID: UUID?
    @Published public var activeContent: AnyView?
    @Published public var activeAnchor: UnitPoint = .top

    public func show(id: UUID, content: AnyView, anchor: UnitPoint = .top) {
        activeID = id
        activeContent = content
        activeAnchor = anchor
    }

    public func hide(id: UUID) {
        if activeID == id {
            activeID = nil
            activeContent = nil
        }
    }
}

// MARK: - Anchor key

public struct PortalAnchorKey: PreferenceKey {
    public typealias Value = [UUID: Anchor<CGRect>]
    public nonisolated(unsafe) static var defaultValue: Value = [:]
    public static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue()) { $1 }
    }
}

// MARK: - PortalOverlay

/// Use this view INSIDE `.overlayPreferenceValue(PortalAnchorKey.self)` placed
/// on your root ScrollView.  It subscribes to `PortalHost.shared` and renders
/// the currently active portal at the correct position.
public struct PortalOverlay: View {
    let anchors: [UUID: Anchor<CGRect>]

    public init(anchors: [UUID: Anchor<CGRect>]) {
        self.anchors = anchors
    }

    public var body: some View {
        PortalOverlayBody(anchors: anchors)
    }
}

private struct PortalOverlayBody: View {
    @ObservedObject private var host = PortalHost.shared
    let anchors: [UUID: Anchor<CGRect>]

    var body: some View {
        GeometryReader { geo in
            if let id = host.activeID,
               let anchor = anchors[id],
               let content = host.activeContent
            {
                let rect = geo[anchor]
                content
                    .frame(minWidth: rect.width, alignment: .topLeading)
                    .fixedSize(horizontal: true, vertical: false)
                    .offset(x: rect.minX, y: rect.maxY + 6)
                    .transition(
                        .opacity
                            .combined(with: .scale(scale: 0.95, anchor: host.activeAnchor))
                            .combined(with: .offset(.init(width: 0, height: -8)))
                    )
                    .zIndex(10_000)
            }
        }
        .animation(.easeOut(duration: 0.15), value: host.activeID)
        .allowsHitTesting(host.activeID != nil)
    }
}
