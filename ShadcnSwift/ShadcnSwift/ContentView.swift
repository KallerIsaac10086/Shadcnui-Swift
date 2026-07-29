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

    @State private var presetInput = ""
    @State private var presetCode = ""
    @State private var showCopiedToast = false

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

                // ── Share / Load Preset ──
                GlassSection(title: "Share Preset") {
                    VStack(spacing: 10) {
                        // Share
                        HStack(spacing: 8) {
                            Text(presetCode.isEmpty ? "Tap to generate…" : presetCode)
                                .font(.system(size: 13, design: .monospaced))
                                .foregroundStyle(presetCode.isEmpty ? .secondary : .primary)
                                .lineLimit(1)
                                .truncationMode(.middle)
                            Spacer()
                            Button {
                                presetCode = encodePreset()
                                #if os(macOS)
                                NSPasteboard.general.clearContents()
                                NSPasteboard.general.setString(presetCode, forType: .string)
                                #else
                                UIPasteboard.general.string = presetCode
                                #endif
                                showCopiedToast = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    showCopiedToast = false
                                }
                            } label: {
                                Image(systemName: showCopiedToast ? "checkmark" : "doc.on.doc")
                                    .font(.system(size: 13))
                            }
                            .shadcnButton(variant: .ghost, size: .iconXs)
                        }

                        // Load
                        HStack(spacing: 8) {
                            TextField("Paste preset code", text: $presetInput)
                                .textFieldStyle(GlassTextFieldStyle())
                                .font(.system(size: 13, design: .monospaced))
                                .autocorrectionDisabled()
                                #if !os(macOS)
                                .textInputAutocapitalization(.never)
                                #endif
                            Button("Apply") { applyPreset(presetInput) }
                                .shadcnButton(variant: .outline, size: .xs)
                                .disabled(presetInput.isEmpty)
                        }
                    }
                }

                Spacer(minLength: 20)
            }
            .padding(16)
        }
        .background(token.background.ignoresSafeArea())
    }

    // MARK: - Preset Encode / Decode

    private let themeIndex: [String: UInt8] = ["zinc":0, "rose":1, "orange":2, "green":3, "blue":4, "violet":5]
    private let themeFromIndex: [UInt8: String] = [0:"zinc", 1:"rose", 2:"orange", 3:"green", 4:"blue", 5:"violet"]
    private let variantIndex: [ButtonVariant: UInt8] = [.default:0, .outline:1, .secondary:2, .ghost:3, .destructive:4, .link:5]
    private let variantFromIndex: [UInt8: ButtonVariant] = [0:.default, 1:.outline, 2:.secondary, 3:.ghost, 4:.destructive, 5:.link]

    func encodePreset() -> String {
        var bytes = [UInt8]()
        bytes.append(1) // version
        let ti = themeIndex[selectedTheme] ?? 0
        let vi = variantIndex[customVariant] ?? 0
        bytes.append(ti << 5 | vi << 2 | (isFullWidth ? 2 : 0) | (cardShowCustomBorder ? 1 : 0))
        bytes.append(UInt8(Int(cornerRadius)))
        bytes.append(UInt8(Int(shadowRadius)))
        bytes.append(UInt8(Int(cardCorner)))
        bytes.append(UInt8(Int(cardBorderWidth * 2)))
        return Data(bytes).base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }

    func applyPreset(_ code: String) {
        var s = code
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        while s.count % 4 != 0 { s += "=" }
        guard let data = Data(base64Encoded: s), data.count >= 6 else { return }

        let bytes = [UInt8](data)
        guard bytes[0] == 1 else { return } // version check

        let b1 = bytes[1]
        selectedTheme = themeFromIndex[b1 >> 5] ?? "zinc"
        customVariant = variantFromIndex[(b1 >> 2) & 0x07] ?? .default
        isFullWidth = (b1 & 2) != 0
        cardShowCustomBorder = (b1 & 1) != 0

        cornerRadius = Double(bytes[2])
        shadowRadius = Double(bytes[3])
        cardCorner = Double(bytes[4])
        cardBorderWidth = Double(bytes[5]) / 2.0

        presetInput = ""
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
