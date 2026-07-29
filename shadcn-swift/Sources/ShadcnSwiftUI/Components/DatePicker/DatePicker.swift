import SwiftUI

// MARK: - DatePicker

/// A date picker component. Corresponds to `<DatePicker>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// @State var date = Date()
/// ShadcnDatePicker("Select date", selection: $date)
/// ShadcnDatePicker("Range", selection: $range, mode: .range)
/// ```
@available(iOS 16.0, macOS 13.0, *)
public struct ShadcnDatePicker: View {
    @Environment(\.shadcnToken) private var token

    public enum Mode: Sendable { case single, range }
    let label: String
    @Binding var selection: Date
    let mode: Mode
    let range: ClosedRange<Date>?

    public init(_ label: String = "", selection: Binding<Date>, mode: Mode = .single, range: ClosedRange<Date>? = nil) {
        self.label = label; self._selection = selection; self.mode = mode; self.range = range
    }

    public var body: some View {
        DatePicker(label, selection: $selection, in: range ?? Date.distantPast...Date.distantFuture, displayedComponents: .date)
            .datePickerStyle(.graphical)
            .tint(token.primary)
    }
}
