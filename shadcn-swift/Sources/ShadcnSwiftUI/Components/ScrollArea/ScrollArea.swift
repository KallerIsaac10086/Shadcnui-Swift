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
    #if os(iOS)
    let showsIndicators: Bool
    #endif
    @ViewBuilder let content: () -> Content

    public init(
        #if os(iOS)
        showsIndicators: Bool = true,
        #endif
        @ViewBuilder content: @escaping () -> Content
    ) {
        #if os(iOS)
        self.showsIndicators = showsIndicators
        #endif
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
