import SwiftUI
import ShadcnSwiftUI

struct ContentView: View {
    @State private var selectedTheme = "zinc"
    @State private var buttonVariant: ButtonVariant = .default

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Theme picker
                Picker("Theme", selection: $selectedTheme) {
                    Text("Zinc").tag("zinc")
                    Text("Rose").tag("rose")
                    Text("Orange").tag("orange")
                    Text("Green").tag("green")
                    Text("Blue").tag("blue")
                    Text("Violet").tag("violet")
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)

                // Current theme indicator
                HStack {
                    Circle()
                        .fill(currentTheme.light.primary)
                        .frame(width: 12, height: 12)
                    Text("Current: \(currentTheme.name.capitalized)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                // Section: Button Variants
                VStack(alignment: .leading, spacing: 12) {
                    Text("Button Variants")
                        .font(.headline)

                    ForEach(ButtonVariant.allCases, id: \.rawValue) { variant in
                        HStack(spacing: 8) {
                            Text(variant.rawValue.capitalized)
                                .font(.caption)
                                .frame(width: 80, alignment: .leading)
                                .foregroundStyle(.secondary)

                            Button("Button") { }
                                .shadcnButton(variant: variant)
                        }
                    }
                }
                .padding(.horizontal, 20)

                // Section: Button Sizes
                VStack(alignment: .leading, spacing: 12) {
                    Text("Button Sizes")
                        .font(.headline)

                    ForEach(ButtonSize.allCases, id: \.rawValue) { size in
                        HStack(spacing: 8) {
                            Text(size.rawValue)
                                .font(.caption)
                                .frame(width: 80, alignment: .leading)
                                .foregroundStyle(.secondary)

                            Button("Button") { }
                                .shadcnButton(size: size)
                        }
                    }
                }
                .padding(.horizontal, 20)

                // Section: Card
                VStack(alignment: .leading, spacing: 12) {
                    Text("Card")
                        .font(.headline)
                        .padding(.horizontal, 20)

                    Card {
                        CardHeader {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    CardTitle("Notifications")
                                    CardDescription("You have 3 unread messages.")
                                }
                                Spacer()
                                Button { } label: {
                                    Image(systemName: "bell.badge")
                                }
                                .shadcnButton(variant: .ghost, size: .iconSm)
                            }
                        }
                        CardContent {
                            Text("Your subscription renews on August 1, 2026.")
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                        }
                        CardFooter {
                            Button("Dismiss") { }
                                .shadcnButton(variant: .outline, size: .sm)
                            Button("View All") { }
                                .shadcnButton(variant: .default, size: .sm)
                        }
                    }
                    .padding(.horizontal, 20)
                }

                Spacer(minLength: 40)
            }
        }
        .background(ThemeBackground())
        .shadcnTheme(currentTheme)
    }

    private var currentTheme: Theme {
        switch selectedTheme {
        case "rose":    return Themes.rose
        case "orange":  return Themes.orange
        case "green":   return Themes.green
        case "blue":    return Themes.blue
        case "violet":  return Themes.violet
        default:        return Themes.zinc
        }
    }
}

/// Fills the background with the current theme's background color.
private struct ThemeBackground: View {
    @Environment(\.shadcnToken) private var token

    var body: some View {
        token.background.ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
