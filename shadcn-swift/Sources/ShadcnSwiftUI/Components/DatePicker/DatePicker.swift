import SwiftUI

// MARK: - ShadcnDatePicker

/// A popover-based date picker. Corresponds to `<DatePicker>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// @State var date = Date()
/// ShadcnDatePicker(selection: $date)
/// ```
public struct ShadcnDatePicker: View {
    @Environment(\.shadcnToken) private var token

    @Binding var selection: Date
    @State private var isOpen = false

    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f
    }()

    public init(selection: Binding<Date>) {
        self._selection = selection
    }

    // MARK: - Body

    public var body: some View {
        ZStack(alignment: .topTrailing) {
            // Full-screen backdrop
            if isOpen {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeOut(duration: 0.15)) { isOpen = false }
                    }
            }

            VStack(alignment: .trailing, spacing: 4) {
                triggerButton

                if isOpen {
                    calendarPanel
                        .fixedSize(horizontal: true, vertical: false)
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                        .zIndex(100)
                }
            }
        }
        .animation(.easeOut(duration: 0.15), value: isOpen)
    }

    // MARK: - Trigger

    private var triggerButton: some View {
        Button {
            withAnimation(.easeOut(duration: 0.15)) { isOpen.toggle() }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .font(.system(size: 14))
                    .foregroundStyle(token.mutedForeground)

                Text(dateFormatter.string(from: selection))
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(token.foreground)

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 36)
            .padding(.horizontal, 12)
            .background(token.background)
            .clipShape(RoundedRectangle(cornerRadius: token.radius))
            .overlay(
                RoundedRectangle(cornerRadius: token.radius)
                    .strokeBorder(token.border, lineWidth: 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.borderless)
        .frame(width: 240)
    }

    // MARK: - Calendar panel

    private var calendarPanel: some View {
        CalendarView(selection: $selection, onSelect: { isOpen = false })
            .background(token.popover)
            .clipShape(RoundedRectangle(cornerRadius: token.radius))
            .overlay(
                RoundedRectangle(cornerRadius: token.radius)
                    .strokeBorder(token.border, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.12), radius: 12, y: 6)
    }
}
