import SwiftUI

// MARK: - Combobox

/// An autocomplete input with dropdown suggestions. Corresponds to `<Combobox>` in shadcn/ui.
public struct Combobox: View {
    @Environment(\.shadcnToken) private var token

    @Binding var query: String
    @Binding var selection: String?
    let items: [String]
    @FocusState private var isFocused: Bool
    @State private var showDropdown = false
    @State private var triggerFrame: CGRect = .zero

    public init(query: Binding<String>, selection: Binding<String?>, items: [String]) {
        self._query = query
        self._selection = selection
        self.items = items
    }

    public var body: some View {
        ZStack {
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
                .onTapGesture {
                    showDropdown = true
                    isFocused = true
                }
                .background(
                    GeometryReader { geo in
                        Color.clear.onAppear { triggerFrame = geo.frame(in: .global) }
                    }
                )
            }
            .onChange(of: isFocused) { _, focused in
                if focused { showDropdown = true }
            }

            if showDropdown {
                ZStack(alignment: .top) {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showDropdown = false
                            isFocused = false
                        }

                    if !items.isEmpty {
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(items, id: \.self) { item in
                                    Button {
                                        selection = item
                                        query = item
                                        showDropdown = false
                                        isFocused = false
                                    } label: {
                                        HStack {
                                            Text(item).font(.system(size: 14)).foregroundColor(token.foreground)
                                            Spacer()
                                            if selection == item {
                                                Image(systemName: "checkmark")
                                                    .font(.system(size: 12, weight: .bold))
                                                    .foregroundColor(token.primary)
                                            }
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(selection == item ? token.muted : Color.clear)
                                        .contentShape(Rectangle())
                                    }
                                    .buttonStyle(.borderless)
                                }
                            }
                        }
                        .frame(maxHeight: 240)
                        .padding(.vertical, 4)
                        .background(token.popover)
                        .clipShape(RoundedRectangle(cornerRadius: token.radius))
                        .overlay(RoundedRectangle(cornerRadius: token.radius).strokeBorder(token.border, lineWidth: 1))
                        .shadow(color: .black.opacity(0.12), radius: 12, y: 4)
                        .padding(.horizontal, 16)
                        .padding(.top, triggerFrame.maxY + 4)
                    }
                }
            }
        }
    }
}
