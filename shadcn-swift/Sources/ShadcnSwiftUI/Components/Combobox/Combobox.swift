import SwiftUI

// MARK: - Combobox

/// An autocomplete input with dropdown suggestions. Corresponds to `<Combobox>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// @State var query = ""; @State var selection: String?
/// let items = ["Apple", "Banana", "Cherry"]
/// Combobox(query: $query, selection: $selection, items: items.filter { query.isEmpty || $0.contains(query) })
/// ```
public struct Combobox: View {
    @Environment(\.shadcnToken) private var token

    @Binding var query: String
    @Binding var selection: String?
    let items: [String]
    @FocusState private var isFocused: Bool

    public init(query: Binding<String>, selection: Binding<String?>, items: [String]) {
        self._query = query
        self._selection = selection
        self.items = items
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                TextField("Search...", text: $query)
                    .focused($isFocused)
                if !query.isEmpty {
                    Button { query = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(token.mutedForeground)
                    }
                    .buttonStyle(.borderless)
                }
            }
            .font(.system(size: 14))
            .padding(.horizontal, 10)
            .frame(height: 36)
            .background(token.card)
            .clipShape(RoundedRectangle(cornerRadius: token.radius))
            .overlay(RoundedRectangle(cornerRadius: token.radius).strokeBorder(token.border, lineWidth: 1))

            if isFocused && !items.isEmpty {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(items, id: \.self) { item in
                            Button {
                                selection = item
                                query = item
                                isFocused = false
                            } label: {
                                HStack {
                                    Text(item).font(.system(size: 14))
                                    Spacer()
                                    if selection == item {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(token.primary)
                                    }
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.borderless)
                            .background(selection == item ? token.muted : Color.clear)
                        }
                    }
                }
                .frame(maxHeight: 200)
                .background(token.popover)
                .clipShape(RoundedRectangle(cornerRadius: token.radius))
                .overlay(RoundedRectangle(cornerRadius: token.radius).strokeBorder(token.border, lineWidth: 1))
                .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
            }
        }
    }
}
