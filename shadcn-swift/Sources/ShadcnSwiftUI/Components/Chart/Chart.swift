import SwiftUI
import Charts

/// Chart config maps data keys to colors and labels.
public struct ChartConfig {
    public var colors: [String: Color] = [:]
    public var labels: [String: String] = [:]
    public init(colors: [String: Color] = [:], labels: [String: String] = [:]) {
        self.colors = colors; self.labels = labels
    }
}

/// Wraps a Swift Charts `Chart` in a styled container.
public struct ChartContainer<Content: View>: View {
    @Environment(\.shadcnToken) private var token
    let config: ChartConfig
    @ViewBuilder let content: () -> Content

    public init(config: ChartConfig = .init(), @ViewBuilder content: @escaping () -> Content) {
        self.config = config; self.content = content
    }

    public var body: some View {
        VStack(spacing: 8) {
            content()
                .aspectRatio(16 / 9, contentMode: .fit)
                .frame(minWidth: 320, minHeight: 200)
            if !config.labels.isEmpty {
                ChartLegend(config: config)
            }
        }
        .padding(12)
        .background(token.card)
        .clipShape(RoundedRectangle(cornerRadius: token.radius))
        .overlay(RoundedRectangle(cornerRadius: token.radius).strokeBorder(token.border, lineWidth: 1))
    }
}

/// Tooltip popup overlay for chart data points.
public struct ChartTooltip: View {
    @Environment(\.shadcnToken) private var token
    let title: String; let value: String; let color: Color

    public init(title: String, value: String, color: Color = .primary) {
        self.title = title; self.value = value; self.color = color
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 2).fill(color).frame(width: 8, height: 8)
                Text(title).font(.system(size: 12)).foregroundColor(token.mutedForeground)
            }
            Text(value).font(.system(size: 14, weight: .bold, design: .monospaced)).foregroundColor(token.foreground)
        }
        .padding(10)
        .background(token.popover)
        .clipShape(RoundedRectangle(cornerRadius: token.radius))
        .overlay(RoundedRectangle(cornerRadius: token.radius).strokeBorder(token.border, lineWidth: 1))
        .shadow(color: .black.opacity(0.1), radius: 6, y: 2)
    }
}

/// Legend row showing colour swatches + labels.
public struct ChartLegend: View {
    @Environment(\.shadcnToken) private var token
    let items: [LegendItem]

    public struct LegendItem: Identifiable {
        public let id = UUID(); public let label: String; public let color: Color
        public init(label: String, color: Color) { self.label = label; self.color = color }
    }

    public init(items: [LegendItem]) { self.items = items }

    public init(config: ChartConfig) {
        self.items = config.labels.map { k, v in
            LegendItem(label: v, color: config.colors[k] ?? .gray)
        }
    }

    public var body: some View {
        HStack(spacing: 16) {
            ForEach(items) { item in
                HStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 2).fill(item.color).frame(width: 12, height: 12)
                    Text(item.label).font(.system(size: 12)).foregroundColor(token.mutedForeground)
                }
            }
        }
    }
}
