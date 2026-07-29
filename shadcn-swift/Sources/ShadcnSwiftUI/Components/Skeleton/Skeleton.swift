import SwiftUI

/// Animated pulse placeholder. Corresponds to `<Skeleton>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// Skeleton().frame(width: 200, height: 16)
/// Skeleton().frame(height: 100) // full-width block
/// ```
public struct Skeleton: View {
    @Environment(\.shadcnToken) private var token

    public init() {}

    public var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(token.muted)
            .opacity(pulseOpacity)
            .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: pulseOpacity)
            .onAppear { pulseOpacity = 1 }
    }

    @State private var pulseOpacity: Double = 0.35
}
