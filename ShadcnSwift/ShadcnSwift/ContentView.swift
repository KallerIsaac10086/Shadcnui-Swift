import SwiftUI
import ShadcnSwiftUI

struct ContentView: View {
    @State private var selectedTheme = "zinc"

    // ── Button customizer state ──
    @State private var customVariant: ButtonVariant = .default
    @State private var cornerRadius: Double = 0      // 0 = use default
    @State private var isFullWidth = false
    @State private var shadowRadius: Double = 0
    @State private var buttonLabel = "Customize Me"

    // ── Card customizer state ──
    @State private var cardCorner: Double = 15       // default ~15pt
    @State private var cardBorderWidth: Double = 1
    @State private var cardShowCustomBorder = false

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

                // ──────── Live Button Customizer ────────
                VStack(alignment: .leading, spacing: 16) {
                    Text("Live Button Customizer")
                        .font(.headline)

                    // Variant picker
                    HStack {
                        Text("Variant")
                            .font(.caption)
                            .frame(width: 80, alignment: .leading)
                            .foregroundStyle(.secondary)
                        Picker("", selection: $customVariant) {
                            ForEach(ButtonVariant.allCases, id: \.rawValue) { v in
                                Text(v.rawValue.capitalized).tag(v)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    // Corner radius
                    VStack(spacing: 4) {
                        HStack {
                            Text("Corner radius")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(cornerRadius == 0 ? "default" : "\(Int(cornerRadius))pt")
                                .font(.caption.monospacedDigit())
                                .foregroundStyle(.secondary)
                        }
                        Slider(value: $cornerRadius, in: 0...50, step: 1)
                    }

                    // Shadow
                    VStack(spacing: 4) {
                        HStack {
                            Text("Shadow")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("\(Int(shadowRadius))pt")
                                .font(.caption.monospacedDigit())
                                .foregroundStyle(.secondary)
                        }
                        Slider(value: $shadowRadius, in: 0...20, step: 1)
                    }

                    // Full width toggle
                    Toggle("Full width", isOn: $isFullWidth)
                        .font(.caption)

                    // Label text
                    HStack {
                        Text("Label")
                            .font(.caption)
                            .frame(width: 80, alignment: .leading)
                            .foregroundStyle(.secondary)
                        TextField("", text: $buttonLabel)
                            .textFieldStyle(.roundedBorder)
                            .font(.system(size: 14))
                    }

                    // Live preview
                    HStack {
                        Text("Preview")
                            .font(.caption)
                            .frame(width: 80, alignment: .leading)
                            .foregroundStyle(.secondary)
                        Button(buttonLabel) { }
                            .shadcnButton(variant: customVariant, size: .default) { label in
                                var view = label
                                if cornerRadius > 0 {
                                    view = view.cornerRadius(cornerRadius)
                                }
                                if isFullWidth {
                                    view = view.frame(maxWidth: .infinity)
                                }
                                if shadowRadius > 0 {
                                    view = view.shadow(
                                        color: currentTheme.light.primary.opacity(0.35),
                                        radius: shadowRadius,
                                        y: shadowRadius / 2
                                    )
                                }
                                return AnyView(view)
                            }
                    }
                }
                .padding(.horizontal, 20)

                // ──────── Live Card Customizer ────────
                VStack(alignment: .leading, spacing: 16) {
                    Text("Live Card Customizer")
                        .font(.headline)

                    VStack(spacing: 4) {
                        HStack {
                            Text("Corner radius")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("\(Int(cardCorner))pt")
                                .font(.caption.monospacedDigit())
                                .foregroundStyle(.secondary)
                        }
                        Slider(value: $cardCorner, in: 0...40, step: 1)
                    }

                    VStack(spacing: 4) {
                        HStack {
                            Text("Border width")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(String(format: "%.0fpt", cardBorderWidth))
                                .font(.caption.monospacedDigit())
                                .foregroundStyle(.secondary)
                        }
                        Slider(value: $cardBorderWidth, in: 0...6, step: 0.5)
                    }

                    Toggle("Colored border (uses theme primary)", isOn: $cardShowCustomBorder)
                        .font(.caption)

                    Card(customStyle: { card in
                        AnyView(
                            card
                                .cornerRadius(cardCorner)
                                .overlay(
                                    RoundedRectangle(cornerRadius: cardCorner)
                                        .strokeBorder(
                                            cardShowCustomBorder
                                                ? currentTheme.light.primary
                                                : currentTheme.light.border,
                                            lineWidth: cardBorderWidth
                                        )
                                )
                        )
                    }) {
                        CardHeader {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    CardTitle("Interactive Card")
                                    CardDescription("Adjust the sliders above to see changes.")
                                }
                                Spacer()
                            }
                        }
                        CardContent {
                            HStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Corner: \(Int(cardCorner))pt")
                                    Text("Border: \(String(format: "%.1f", cardBorderWidth))pt")
                                }
                                .font(.system(size: 13))
                                .foregroundStyle(.secondary)
                                Spacer()
                                Circle()
                                    .fill(cardShowCustomBorder
                                        ? currentTheme.light.primary
                                        : Color.clear)
                                    .frame(width: 24, height: 24)
                                    .overlay(
                                        Circle()
                                            .strokeBorder(currentTheme.light.border, lineWidth: 1)
                                    )
                            }
                        }
                        CardFooter {
                            Button("Reset") {
                                cardCorner = 15
                                cardBorderWidth = 1
                                cardShowCustomBorder = false
                            }
                            .shadcnButton(variant: .outline, size: .sm)
                        }
                    }
                    .padding(.horizontal, 20)
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
