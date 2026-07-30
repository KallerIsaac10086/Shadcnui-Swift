import SwiftUI

// MARK: - CalendarView

/// A reusable calendar grid for selecting a single date.
/// Corresponds to `<Calendar>` in shadcn/ui.
public struct CalendarView: View {
    @Environment(\.shadcnToken) private var token

    @Binding var selection: Date
    @State private var currentMonth: Date

    private let calendar = Calendar.current
    private let weekdaySymbols: [String]
    private let onSelect: (() -> Void)?

    /// 7 个等宽列，保证表头、星期、日期三处严格对齐。
    private let columns: [GridItem] = Array(
        repeating: GridItem(.flexible(), spacing: 0),
        count: 7
    )

    public init(selection: Binding<Date>, onSelect: (() -> Void)? = nil) {
        self._selection = selection
        let now = selection.wrappedValue
        self._currentMonth = State(
            initialValue: Calendar.current.date(
                from: Calendar.current.dateComponents([.year, .month], from: now)
            )!
        )
        self.weekdaySymbols = Calendar.current.shortStandaloneWeekdaySymbols
        self.onSelect = onSelect
    }

    public var body: some View {
        VStack(spacing: 12) {
            header
            weekdayRow
            dayGrid
        }
        .frame(width: 260)
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 0) {
            Button {
                withAnimation {
                    currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(token.mutedForeground)
                    .frame(width: 28, height: 28)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.borderless)

            Text(monthYearString(currentMonth))
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(token.foreground)
                .lineLimit(1)
                .frame(maxWidth: .infinity)

            Button {
                withAnimation {
                    currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(token.mutedForeground)
                    .frame(width: 28, height: 28)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.borderless)
        }
        .padding(.horizontal, 4)
    }

    // MARK: - Weekday Row

    private var weekdayRow: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(0..<7, id: \.self) { i in
                Text(weekdaySymbols[(i + calendar.firstWeekday - 1) % 7])
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(token.mutedForeground)
                    .frame(maxWidth: .infinity)
                    .frame(height: 24)
            }
        }
    }

    // MARK: - Day Grid

    private var dayGrid: some View {
        let days = generateDays()
        return LazyVGrid(columns: columns, spacing: 2) {
            ForEach(0..<42, id: \.self) { idx in
                if idx < days.count, let day = days[idx] {
                    dayCell(day)
                } else {
                    Color.clear
                        .aspectRatio(1, contentMode: .fit)
                }
            }
        }
    }

    private func dayCell(_ date: Date) -> some View {
        let isSelected = calendar.isDate(date, inSameDayAs: selection)
        let isToday = calendar.isDateInToday(date)
        let isCurrentMonth = calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)

        return Button {
            selection = date
            onSelect?()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: token.radius)
                    .fill(
                        isSelected ? token.primary :
                            isToday ? token.muted : Color.clear
                    )

                Text("\(calendar.component(.day, from: date))")
                    .font(.system(size: 13, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(
                        isSelected ? token.primaryForeground :
                            isCurrentMonth ? token.foreground :
                            token.mutedForeground.opacity(0.4)
                    )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.borderless)
        .aspectRatio(1, contentMode: .fit)
    }

    // MARK: - Helpers

    private func monthYearString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }

    private func generateDays() -> [Date?] {
        guard let firstOfMonth = calendar.date(
            from: calendar.dateComponents([.year, .month], from: currentMonth)
        ),
        let range = calendar.range(of: .day, in: .month, for: firstOfMonth) else {
            return []
        }

        let weekdayOffset = (calendar.component(.weekday, from: firstOfMonth) - calendar.firstWeekday + 7) % 7

        var days: [Date?] = []
        // Padding before first day
        for _ in 0..<weekdayOffset {
            days.append(nil)
        }
        // Days of the month
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                days.append(date)
            }
        }
        // Padding to fill 6 rows (42 cells)
        while days.count < 42 {
            days.append(nil)
        }
        return days
    }
}