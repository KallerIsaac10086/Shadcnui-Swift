import SwiftUI

// MARK: - AspectRatio

/// Constrains content to a given aspect ratio. Corresponds to `<AspectRatio>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// AspectRatio(16/9) {
///     Image("hero").resizable().scaledToFill()
/// }
/// ```
public struct AspectRatio<Content: View>: View {
    let ratio: CGFloat
    @ViewBuilder let content: () -> Content

    public init(_ ratio: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.ratio = ratio
        self.content = content
    }

    public var body: some View {
        content()
            .aspectRatio(ratio, contentMode: .fit)
    }
}
