import SwiftUI
import ShadcnSwiftUI

// MARK: - Root View

struct ContentView: View {
    @State private var selectedTheme = "zinc"

    var body: some View {
        TabView {
            ComponentList(selectedTheme: $selectedTheme)
                .tabItem {
                    Label("Components", systemImage: "square.grid.2x2")
                }

            Customizer(selectedTheme: $selectedTheme)
                .tabItem {
                    Label("Customizer", systemImage: "slider.horizontal.3")
                }
        }
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

// MARK: - Shared Theme Picker

struct ThemePicker: View {
    @Binding var selectedTheme: String

    var body: some View {
        VStack(spacing: 8) {
            Picker("Theme", selection: $selectedTheme) {
                Text("Zinc").tag("zinc")
                Text("Rose").tag("rose")
                Text("Orange").tag("orange")
                Text("Green").tag("green")
                Text("Blue").tag("blue")
                Text("Violet").tag("violet")
            }
            .pickerStyle(.segmented)
        }
    }
}

// MARK: - Glass Section Wrapper

struct GlassSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            content()
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Tab 1: Component List

struct ComponentList: View {
    @Environment(\.shadcnToken) private var token
    @Binding var selectedTheme: String

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ThemePicker(selectedTheme: $selectedTheme)

                GlassSection(title: "Button Variants") {
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

                GlassSection(title: "Button Sizes") {
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

                GlassSection(title: "Card") {
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
                }

                Spacer(minLength: 20)
            }
            .padding(16)
        }
        .background(token.background.ignoresSafeArea())
    }
}

// MARK: - Tab 2: Customizer

struct Customizer: View {
    @Environment(\.shadcnToken) private var token
    @Binding var selectedTheme: String

    @State private var customVariant: ButtonVariant = .default
    @State private var cornerRadius: Double = 0
    @State private var isFullWidth = false
    @State private var shadowRadius: Double = 0
    @State private var buttonLabel = "Customize Me"

    @State private var cardCorner: Double = 15
    @State private var cardBorderWidth: Double = 1
    @State private var cardShowCustomBorder = false

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

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ThemePicker(selectedTheme: $selectedTheme)

                // ── Button Customizer ──
                GlassSection(title: "Button Customizer") {
                    VStack(spacing: 14) {
                        // Variant
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
                                Text("Corner")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(cornerRadius == 0 ? "default" : "\(Int(cornerRadius))pt")
                                    .font(.caption.monospacedDigit())
                                    .foregroundStyle(.secondary)
                            }
                            Slider(value: $cornerRadius, in: 0...50, step: 1)
                                .tint(currentTheme.light.primary)
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
                                .tint(currentTheme.light.primary)
                        }

                        Toggle("Full width", isOn: $isFullWidth)
                            .font(.caption)

                        HStack {
                            Text("Label")
                                .font(.caption)
                                .frame(width: 80, alignment: .leading)
                                .foregroundStyle(.secondary)
                            TextField("", text: $buttonLabel)
                                .textFieldStyle(GlassTextFieldStyle())
                                .font(.system(size: 14))
                        }

                        // Live preview
                        HStack {
                            Text("Preview")
                                .font(.caption)
                                .frame(width: 80, alignment: .leading)
                                .foregroundStyle(.secondary)
                            Button(buttonLabel) { }
                                .shadcnButton(
                                    variant: customVariant,
                                    size: .default,
                                    cornerRadius: cornerRadius > 0 ? cornerRadius : nil
                                ) { label in
                                    var view: AnyView = label
                                    if isFullWidth {
                                        view = AnyView(view.frame(maxWidth: .infinity))
                                    }
                                    if shadowRadius > 0 {
                                        view = AnyView(view.shadow(
                                            color: currentTheme.light.primary.opacity(0.35),
                                            radius: shadowRadius,
                                            y: shadowRadius / 2
                                        ))
                                    }
                                    return view
                                }
                        }
                    }
                }

                // ── Card Customizer ──
                GlassSection(title: "Card Customizer") {
                    VStack(spacing: 14) {
                        VStack(spacing: 4) {
                            HStack {
                                Text("Corner")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("\(Int(cardCorner))pt")
                                    .font(.caption.monospacedDigit())
                                    .foregroundStyle(.secondary)
                            }
                            Slider(value: $cardCorner, in: 0...40, step: 1)
                                .tint(currentTheme.light.primary)
                        }

                        VStack(spacing: 4) {
                            HStack {
                                Text("Border")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(String(format: "%.0f", cardBorderWidth) + "pt")
                                    .font(.caption.monospacedDigit())
                                    .foregroundStyle(.secondary)
                            }
                            Slider(value: $cardBorderWidth, in: 0...6, step: 0.5)
                                .tint(currentTheme.light.primary)
                        }

                        Toggle("Colored border", isOn: $cardShowCustomBorder)
                            .font(.caption)

                        Card(
                            cornerRadius: cardCorner,
                            borderWidth: cardBorderWidth,
                            borderColor: cardShowCustomBorder ? currentTheme.light.primary : nil
                        ) {
                            CardHeader {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        CardTitle("Interactive Card")
                                        CardDescription("Adjust the sliders above.")
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
                                        .fill(cardShowCustomBorder ? currentTheme.light.primary : .clear)
                                        .frame(width: 24, height: 24)
                                        .overlay(Circle().strokeBorder(currentTheme.light.border, lineWidth: 1))
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
                    }
                }

                Spacer(minLength: 20)
            }
            .padding(16)
        }
        .background(token.background.ignoresSafeArea())
    }
}

// MARK: - Glass TextField Style

struct GlassTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(.secondary.opacity(0.2), lineWidth: 0.5)
            )
    }
}

#Preview {
    ContentView()
}
