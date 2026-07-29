import SwiftUI

// MARK: - AlertDialog Modifier

/// A modal confirmation dialog. Corresponds to `<AlertDialog>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// @State var showConfirm = false
/// Button("Delete") { showConfirm = true }
///     .alertDialog(isPresented: $showConfirm, size: .sm) {
///         AlertDialogHeader {
///             AlertDialogTitle("Delete Chat")
///             AlertDialogDescription("This action is permanent.")
///         }
///         AlertDialogFooter {
///             AlertDialogCancel("Cancel") { showConfirm = false }
///             AlertDialogAction("Delete", variant: .destructive) { showConfirm = false }
///         }
///     }
/// ```
public struct AlertDialogModifier<CardContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let size: DialogSize
    @ViewBuilder let content: () -> CardContent

    public init(isPresented: Binding<Bool>, size: DialogSize = .sm, @ViewBuilder content: @escaping () -> CardContent) {
        self._isPresented = isPresented
        self.size = size
        self.content = content
    }

    public func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .transition(.opacity)

                VStack(spacing: 16) {
                    self.content()
                }
                .frame(maxWidth: .infinity)
                .padding(24)
                .background(DesignToken.defaultValue.card)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(DesignToken.defaultValue.border, lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.2), radius: 24, y: 8)
                .padding(.horizontal, 20)
                .frame(maxWidth: size == .sm ? 360 : 440)
                .transition(.scale(scale: 0.95).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isPresented)
    }
}

extension DesignToken {
    fileprivate static let defaultValue = Themes.zinc.light
}

public extension View {
    func alertDialog<Content: View>(
        isPresented: Binding<Bool>,
        size: DialogSize = .sm,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(AlertDialogModifier(isPresented: isPresented, size: size, content: content))
    }
}

// MARK: - Sub-components

public struct AlertDialogHeader<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View {
        VStack(alignment: .center, spacing: 6) { content() }
    }
}

public struct AlertDialogTitle: View {
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text).font(.system(size: 16, weight: .semibold)).multilineTextAlignment(.center)
    }
}

public struct AlertDialogDescription: View {
    let text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text).font(.system(size: 14)).foregroundStyle(.secondary).multilineTextAlignment(.center)
    }
}

public struct AlertDialogFooter<Content: View>: View {
    @ViewBuilder let content: () -> Content
    public init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    public var body: some View {
        HStack(spacing: 8) { Spacer(); content(); Spacer() }
    }
}

public struct AlertDialogAction: View {
    let label: String
    let variant: ButtonVariant
    let action: () -> Void
    public init(_ label: String, variant: ButtonVariant = .default, action: @escaping () -> Void) {
        self.label = label; self.variant = variant; self.action = action
    }
    public var body: some View {
        Button(label, action: action).shadcnButton(variant: variant, size: .default)
    }
}

public struct AlertDialogCancel: View {
    let label: String
    let action: () -> Void
    public init(_ label: String = "Cancel", action: @escaping () -> Void) {
        self.label = label; self.action = action
    }
    public var body: some View {
        Button(label, action: action).shadcnButton(variant: .outline, size: .default)
    }
}
