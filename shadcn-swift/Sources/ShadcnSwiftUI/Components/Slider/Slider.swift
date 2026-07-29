import SwiftUI

// MARK: - Slider

/// A shadcn/ui-style slider for selecting a value from a range.
///
/// Usage:
/// ```swift
/// @State var volume = 0.5
/// Slider(value: $volume, in: 0...1, step: 0.1)
/// ```
public struct Slider: View {
    @Environment(\.shadcnToken) private var token
    @Environment(\.isEnabled) private var isEnabled

    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double?

    public init(
        value: Binding<Double>,
        in range: ClosedRange<Double> = 0...1,
        step: Double? = nil
    ) {
        self._value = value
        self.range = range
        self.step = step
    }

    public var body: some View {
        GeometryReader { geo in
            let thumbD: CGFloat = 20
            let trackH: CGFloat = 4
            let halfThumb = thumbD / 2
            let available = max(geo.size.width - thumbD, 1)
            let fraction = CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound))
            let clampedFraction = min(max(fraction, 0), 1)
            let thumbX = halfThumb + available * clampedFraction

            ZStack(alignment: .leading) {
                Capsule().fill(token.muted).frame(height: trackH)
                Capsule().fill(token.primary).frame(width: max(0, thumbX), height: trackH)
                Circle()
                    .fill(token.background)
                    .overlay(Circle().strokeBorder(token.primary, lineWidth: 2))
                    .shadow(color: .black.opacity(0.1), radius: 2, y: 1)
                    .frame(width: thumbD, height: thumbD)
                    .offset(x: thumbX - halfThumb)
            }
            .frame(height: thumbD)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { g in
                        let raw = Double((g.location.x - halfThumb) / available)
                        let clamped = min(max(raw, 0), 1)
                        let newValue = range.lowerBound + clamped * (range.upperBound - range.lowerBound)
                        value = applyStep(newValue)
                    }
            )
        }
        .frame(height: 44)
        .opacity(isEnabled ? 1 : 0.5)
    }

    private func applyStep(_ raw: Double) -> Double {
        guard let step, step > 0 else {
            return min(max(raw, range.lowerBound), range.upperBound)
        }
        let steps = ((raw - range.lowerBound) / step).rounded()
        let stepped = range.lowerBound + steps * step
        return min(max(stepped, range.lowerBound), range.upperBound)
    }
}
