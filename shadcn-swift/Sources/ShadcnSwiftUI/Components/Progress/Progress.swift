import SwiftUI

/// Progress bar. Corresponds to `<Progress>` in shadcn/ui.
///
/// Track: 4pt high, `token.muted` background. Indicator: `token.primary` fill.
///
/// Usage: `Progress(value: 0.6)` or `Progress() // indeterminate`
public struct Progress: View {
    @Environment(\.shadcnToken) private var token

    let value: Double?
    let height: CGFloat

    public init(value: Double? = nil, height: CGFloat = 4) {
        self.value = value
        self.height = height
    }

    public var body: some View {
        if let v = value {
            determinateProgress(value: v)
        } else {
            indeterminateProgress
        }
    }

    @ViewBuilder
    private func determinateProgress(value: Double) -> some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(token.muted).frame(height: height)
                Capsule().fill(token.primary)
                    .frame(width: geo.size.width * min(max(value, 0), 1), height: height)
                    .animation(.easeInOut(duration: 0.3), value: value)
            }
        }
        .frame(height: height)
    }

    @State private var offsetX: CGFloat = -200
    @State private var timer: Timer?

    private var indeterminateProgress: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(token.muted).frame(height: height)
                Capsule().fill(token.primary)
                    .frame(width: geo.size.width * 0.4, height: height)
                    .offset(x: offsetX)
            }
        }
        .frame(height: height)
        .onAppear { startIndeterminate() }
        .onDisappear { timer?.invalidate() }
    }

    private func startIndeterminate() {
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: true)) {
            offsetX = 200
        }
    }
}
