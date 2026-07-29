import SwiftUI

// MARK: - Spinner

/// A loading spinner. Corresponds to `<Spinner>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// Spinner()
/// Spinner().frame(width: 24, height: 24)
/// ```
public struct Spinner: View {
    @Environment(\.shadcnToken) private var token

    public init() {}

    public var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .tint(token.primary)
    }
}
