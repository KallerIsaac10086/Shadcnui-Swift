import SwiftUI

// MARK: - Avatar Size

public enum AvatarSize: Sendable {
    case sm       // 24pt
    case `default` // 32pt
    case lg       // 40pt
}

// MARK: - Avatar

/// Root avatar container. Renders as a circle with an inset border ring.
public struct Avatar<Content: View>: View {
    @Environment(\.shadcnToken) private var token

    let size: AvatarSize
    let content: () -> Content

    public init(size: AvatarSize = .default, @ViewBuilder content: @escaping () -> Content) {
        self.size = size
        self.content = content
    }

    public var body: some View {
        content()
            .frame(width: diameter, height: diameter)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .strokeBorder(token.border, lineWidth: 1)
            )
    }

    private var diameter: CGFloat {
        switch size {
        case .sm:      return 24
        case .default: return 32
        case .lg:      return 40
        }
    }
}

// MARK: - AvatarImage

/// Avatar image loaded from URL. Falls back to `AvatarFallback` on failure.
public struct AvatarImage: View {
    let url: URL?

    public init(url: URL?) {
        self.url = url
    }

    public var body: some View {
        if let url {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure, .empty:
                    Color.clear
                @unknown default:
                    Color.clear
                }
            }
        }
    }
}

// MARK: - AvatarFallback

/// Shown when `AvatarImage` fails to load or is not provided.
/// Defaults to display initials, accepts custom content.
public struct AvatarFallback<Content: View>: View {
    @Environment(\.shadcnToken) private var token

    let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        content()
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(token.mutedForeground)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(token.muted)
    }
}

// MARK: - AvatarBadge

/// A small dot / icon badge anchored at the bottom-right of the avatar.
public struct AvatarBadge<Content: View>: View {
    let size: AvatarSize
    let content: () -> Content

    public init(size: AvatarSize = .default, @ViewBuilder content: @escaping () -> Content) {
        self.size = size
        self.content = content
    }

    public var body: some View {
        content()
            .font(.system(size: badgeFontSize))
            .frame(width: badgeDiam, height: badgeDiam)
            .background(Color.green)
            .clipShape(Circle())
            .overlay(Circle().strokeBorder(Color.white, lineWidth: 2))
    }

    private var badgeDiam: CGFloat {
        switch size {
        case .sm:      return 8
        case .default: return 10
        case .lg:      return 12
        }
    }

    private var badgeFontSize: CGFloat {
        switch size {
        case .sm:      return 6
        case .default: return 7
        case .lg:      return 7
        }
    }
}

// MARK: - AvatarGroup

/// Stacks multiple avatars with slight overlap.
public struct AvatarGroup<Content: View>: View {
    @Environment(\.shadcnToken) private var token

    let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        HStack(spacing: -8) {
            content()
                .overlay(Circle().strokeBorder(token.background, lineWidth: 2))
        }
    }
}

// MARK: - AvatarGroupCount

/// "+N" counter displayed at the end of an AvatarGroup.
public struct AvatarGroupCount: View {
    @Environment(\.shadcnToken) private var token

    let count: Int

    public init(_ count: Int) {
        self.count = count
    }

    public var body: some View {
        Text("+\(count)")
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(token.mutedForeground)
            .frame(width: 32, height: 32)
            .background(token.muted)
            .clipShape(Circle())
            .overlay(Circle().strokeBorder(token.background, lineWidth: 2))
    }
}

// MARK: - String shorthand

public extension AvatarFallback where Content == Text {
    init(initials: String) {
        self.init {
            Text(initials)
        }
    }
}

public extension AvatarBadge where Content == EmptyView {
    init(size: AvatarSize = .default) {
        self.init(size: size) { EmptyView() }
    }
}
