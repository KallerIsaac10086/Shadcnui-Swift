import SwiftUI

// MARK: - Toast

/// A toast notification overlay. Corresponds to `<Toast>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// @State var toasts: [ToastItem] = []
/// ...
/// ToastView(toasts: $toasts)
/// // Trigger: toasts.append(ToastItem(title: "Saved", type: .success))
/// ```
public struct ToastItem: Identifiable, Sendable {
    public let id = UUID()
    public let title: String
    public let description: String?
    public let type: ToastType
    public init(title: String, description: String? = nil, type: ToastType = .info) {
        self.title = title; self.description = description; self.type = type
    }
}

public enum ToastType: Sendable { case success, info, warning, error }

public struct ToastView: View {
    @Binding var toasts: [ToastItem]

    public init(toasts: Binding<[ToastItem]>) { self._toasts = toasts }

    public var body: some View {
        VStack(spacing: 8) {
            ForEach(toasts) { toast in
                HStack(spacing: 8) {
                    Image(systemName: icon(for: toast.type))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(toast.title).font(.system(size: 14, weight: .medium))
                        if let desc = toast.description {
                            Text(desc).font(.system(size: 12)).foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                    Button { remove(toast) } label: {
                        Image(systemName: "xmark").font(.system(size: 10, weight: .bold))
                    }
                    .buttonStyle(.borderless)
                }
                .padding(12)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.1), radius: 8, y: 2)
                .padding(.horizontal, 16)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .animation(.easeInOut(duration: 0.2), value: toasts.count)
    }

    private func icon(for type: ToastType) -> String {
        switch type {
        case .success: return "checkmark.circle.fill"
        case .info:    return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error:   return "xmark.circle.fill"
        }
    }

    private func remove(_ toast: ToastItem) {
        toasts.removeAll { $0.id == toast.id }
    }
}
