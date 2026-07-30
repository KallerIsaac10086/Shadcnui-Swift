import SwiftUI

// MARK: - ToastType

public enum ToastType: Sendable { case `default`, success, info, warning, error, loading }

public struct ToastAction: Sendable {
    public let label: String
    public let action: @MainActor () -> Void
    public init(label: String, action: @MainActor @escaping () -> Void) {
        self.label = label; self.action = action
    }
}

// MARK: - ToastItem

public struct ToastItem: Identifiable {
    public let id: UUID
    public let title: String
    public let description: String?
    public let type: ToastType
    public let action: ToastAction?
}

// MARK: - ToastPosition

public enum ToastPosition: Sendable {
    case topCenter, topLeft, topRight, bottomCenter, bottomLeft, bottomRight
}

// MARK: - ToastHost

/// Global singleton — call `ToastHost.shared.show(...)` or the top‑level
/// `toast(...)` / `toast.success(...)` helper from anywhere.
@MainActor
public final class ToastHost: ObservableObject {
    public static let shared = ToastHost()

    @Published public var items: [ToastItem] = []
    @Published public var position: ToastPosition = .topCenter
    @Published public var defaultDuration: TimeInterval = 4

    public func show(
        _ title: String,
        description: String? = nil,
        type: ToastType = .default,
        duration: TimeInterval? = nil,
        action: ToastAction? = nil
    ) {
        let id = UUID()
        let item = ToastItem(id: id, title: title, description: description, type: type, action: action)
        withAnimation(.easeOut(duration: 0.25)) { items.append(item) }
        scheduleDismiss(id: id, after: duration ?? defaultDuration)
    }

    public func success(_ title: String, description: String? = nil, duration: TimeInterval? = nil, action: ToastAction? = nil) {
        show(title, description: description, type: .success, duration: duration, action: action)
    }
    public func info(_ title: String, description: String? = nil, duration: TimeInterval? = nil, action: ToastAction? = nil) {
        show(title, description: description, type: .info, duration: duration, action: action)
    }
    public func warning(_ title: String, description: String? = nil, duration: TimeInterval? = nil, action: ToastAction? = nil) {
        show(title, description: description, type: .warning, duration: duration, action: action)
    }
    public func error(_ title: String, description: String? = nil, duration: TimeInterval? = nil, action: ToastAction? = nil) {
        show(title, description: description, type: .error, duration: duration, action: action)
    }

    @discardableResult
    public func loading(_ title: String, description: String? = nil) -> UUID {
        let id = UUID()
        let item = ToastItem(id: id, title: title, description: description, type: .loading, action: nil)
        withAnimation(.easeOut(duration: 0.25)) { items.append(item) }
        return id
    }

    public func dismiss(_ id: UUID?) {
        withAnimation(.easeOut(duration: 0.2)) {
            if let id {
                items.removeAll { $0.id == id }
            } else {
                items.removeAll()
            }
        }
    }

    public func promise<T>(
        _ promise: @escaping () async throws -> T,
        loading: String,
        success: @escaping (T) -> String,
        error: @escaping (Error) -> String = { $0.localizedDescription }
    ) async {
        let id = self.loading(loading)
        do {
            let value = try await promise()
            if let index = items.firstIndex(where: { $0.id == id }) {
                withAnimation(.easeOut(duration: 0.2)) { items.remove(at: index) }
            }
            show(success(value), type: .success)
        } catch let err {
            if let index = items.firstIndex(where: { $0.id == id }) {
                withAnimation(.easeOut(duration: 0.2)) { items.remove(at: index) }
            }
            show(error(err), type: .error)
        }
    }

    // MARK: - Auto dismiss

    private func scheduleDismiss(id: UUID, after seconds: TimeInterval) {
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
            withAnimation(.easeOut(duration: 0.2)) {
                items.removeAll { $0.id == id }
            }
        }
    }
}

// MARK: - Toaster

/// Place this at the root of your view tree (like `<Toaster />` in shadcn).
/// It renders all active toasts in a portal‑style overlay.
///
/// ```swift
/// ZStack {
///     ContentView()
///     Toaster()
/// }
/// ```
public struct Toaster: View {
    @Environment(\.shadcnToken) private var token
    @ObservedObject private var host = ToastHost.shared

    public init() {}

    public var body: some View {
        GeometryReader { _ in
            VStack(spacing: 8) {
                ForEach(host.items) { item in
                    toastRow(item)
                        .transition(
                            host.position == .bottomCenter || host.position == .bottomLeft || host.position == .bottomRight
                                ? .move(edge: .bottom).combined(with: .opacity)
                                : .move(edge: .top).combined(with: .opacity)
                        )
                }
            }
            .frame(maxWidth: min(380, .infinity))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: toastAlignment)
            .padding(16)
            .allowsHitTesting(false)
        }
        .ignoresSafeArea(.keyboard)
    }

    private var toastAlignment: Alignment {
        switch host.position {
        case .topLeft:      return .topLeading
        case .topCenter:    return .top
        case .topRight:     return .topTrailing
        case .bottomLeft:   return .bottomLeading
        case .bottomCenter: return .bottom
        case .bottomRight:  return .bottomTrailing
        }
    }

    @ViewBuilder
    private func toastRow(_ item: ToastItem) -> some View {
        HStack(alignment: .top, spacing: 10) {
            icon(for: item.type)
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(token.foreground)
                if let desc = item.description {
                    Text(desc)
                        .font(.system(size: 13))
                        .foregroundColor(token.mutedForeground)
                }
            }
            Spacer(minLength: 8)
            if let action = item.action {
                Button(action.label) { action.action() }
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(token.primary)
            }
        }
        .padding(12)
        .background(token.popover)
        .clipShape(RoundedRectangle(cornerRadius: token.radius))
        .overlay(
            RoundedRectangle(cornerRadius: token.radius)
                .strokeBorder(token.border, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.12), radius: 8, y: 4)
        .onTapGesture { host.dismiss(item.id) }
        .allowsHitTesting(true)
    }

    @ViewBuilder
    private func icon(for type: ToastType) -> some View {
        switch type {
        case .success:
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
        case .info:
            Image(systemName: "info.circle.fill")
                .foregroundColor(token.primary)
        case .warning:
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.yellow)
        case .error:
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.red)
        case .loading:
            ProgressView().scaleEffect(0.7)
        case .default:
            EmptyView()
        }
    }
}
