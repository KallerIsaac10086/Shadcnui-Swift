import SwiftUI

// MARK: - ScrollArea

/// A scrollable region with optional scroll indicators. Corresponds to `<ScrollArea>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// ScrollArea {
///     VStack { /* long content */ }
/// }
/// .frame(height: 200)
/// ```
public struct ScrollArea<Content: View>: View {
    let showsIndicators: Bool
    @ViewBuilder let content: () -> Content

    public init(
        showsIndicators: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.showsIndicators = showsIndicators
        self.content = content
    }

    public var body: some View {
        ScrollView([.vertical]) {
            content()
        }
        #if os(iOS)
        .scrollIndicators(showsIndicators ? .automatic : .hidden)
        #endif
    }
}
