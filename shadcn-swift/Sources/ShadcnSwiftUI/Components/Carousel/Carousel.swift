import SwiftUI

// MARK: - Carousel

/// A swipeable carousel / page viewer. Corresponds to `<Carousel>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// Carousel {
///     CarouselItem { Color.red.frame(height: 200) }
///     CarouselItem { Color.blue.frame(height: 200) }
///     CarouselItem { Color.green.frame(height: 200) }
/// }
/// ```
public struct Carousel<Content: View>: View {
    @ViewBuilder let content: () -> Content
    @State private var currentIndex = 0

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        TabView(selection: $currentIndex) {
            content()
        }
        #if !os(macOS)
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        #endif
    }
}

// MARK: - CarouselItem

public struct CarouselItem<Content: View>: View {
    let index: Int
    @ViewBuilder let content: () -> Content

    public init(index: Int, @ViewBuilder content: @escaping () -> Content) {
        self.index = index; self.content = content
    }

    public var body: some View {
        content().tag(index)
    }
}
