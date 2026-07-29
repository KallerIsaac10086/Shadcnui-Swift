import SwiftUI

/// Progress bar. Corresponds to `<Progress>` in shadcn/ui.
///
/// Track: 4pt high, `token.muted` background. Indicator: `token.primary` fill.
/// Optional color and label.
///
/// Usage: `Progress(value: 0.6)` or `Progress() // indeterminate`
public struct Progress: View {
    @Environment(\.shadcnToken) private var token

    let value: Double?
    let height: CGFloat
    let color: Color?
    let label: String?

    public init(
        value: Double? = nil,
        height: CGFloat = 4,
        color: Color? = nil,
        label: String? = nil
    ) {
        self.value = value
        self.height = height
        self.color = color
        self.label = label
    }

    private var indicatorColor: Color { color ?? token.primary }

    public var body: some View {
        VStack(spacing: 4) {
            if let v = value {
                determinateProgress(value: v)
            } else {
                indeterminateProgress
            }
            if let label {
                Text(label)
                    .font(.system(size: 12))
                    .foregroundColor(token.mutedForeground)
            }
        }
    }

    @ViewBuilder
    private func determinateProgress(value: Double) -> some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(token.muted).frame(height: height)
                Capsule().fill(indicatorColor)
                    .frame(width: geo.size.width * min(max(value, 0), 1), height: height)
                    .animation(.easeInOut(duration: 0.3), value: value)
            }
        }
        .frame(height: height)
    }

    @State private var offsetX: CGFloat = -200

    private var indeterminateProgress: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(token.muted).frame(height: height)
                Capsule().fill(indicatorColor)
                    .frame(width: geo.size.width * 0.4, height: height)
                    .offset(x: offsetX)
            }
        }
        .frame(height: height)
        .onAppear { startIndeterminate() }
        .onDisappear { /* cleanup handled by animation cancellation */ }
    }

    private func startIndeterminate() {
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: true)) {
            offsetX = 200
        }
    }
}
