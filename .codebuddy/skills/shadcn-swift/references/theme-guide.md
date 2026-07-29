# 主题创建指南

## DesignToken 完整字段

```swift
DesignToken(
    // 基础
    background: Color, foreground: Color,
    // Card
    card: Color, cardForeground: Color,
    // Popover
    popover: Color, popoverForeground: Color,
    // Primary
    primary: Color, primaryForeground: Color,
    // Secondary
    secondary: Color, secondaryForeground: Color,
    // Muted
    muted: Color, mutedForeground: Color,
    // Accent
    accent: Color, accentForeground: Color,
    // Destructive
    destructive: Color, destructiveForeground: Color,
    // Sidebar (8 个)
    sidebar: Color, sidebarForeground: Color,
    sidebarPrimary: Color, sidebarPrimaryForeground: Color,
    sidebarAccent: Color, sidebarAccentForeground: Color,
    sidebarBorder: Color, sidebarRing: Color,
    // Chart (5 个)
    chart1: Color, chart2: Color, chart3: Color, chart4: Color, chart5: Color,
    // Border
    border: Color, input: Color, ring: Color,
    // Radius
    radius: CGFloat
)
```

sidebar 和 chart 字段有默认值 `.clear`，destructiveForeground 默认 `.white`。

## OKLCH 颜色格式

```swift
// 无透明度
.oklch("oklch(0.205 0 0)")

// 小数透明度
.oklch("oklch(1 0 0 / 10%)")

// 完整主题示例 (zinc)
primary: .oklch("oklch(0.21 0.006 285.885)")        // light
primary: .oklch("oklch(0.92 0.004 286.32)")          // dark
destructive: .oklch("oklch(0.577 0.245 27.325)")     // light
destructive: .oklch("oklch(0.704 0.191 22.216)")     // dark
border: .oklch("oklch(0.92 0.004 286.32)")           // light
border: .oklch("oklch(1 0 0 / 10%)")                 // dark (半透明)
```

## 主题结构

```swift
public static let myTheme = Theme(
    name: "my-theme",
    light: DesignToken(
        background: .oklch("oklch(1 0 0)"),
        foreground: .oklch("oklch(0.141 0.005 285.823)"),
        // ... 所有 token
        radius: 10
    ),
    dark: DesignToken(
        background: .oklch("oklch(0.141 0.005 285.823)"),
        foreground: .oklch("oklch(0.985 0 0)"),
        // ... 所有 token
        radius: 10
    )
)
```

## 主题命名规则

- Base color (灰系): neutral, zinc, stone, mauve, olive, mist, taupe
- Accent color (彩色): red, rose, orange, yellow, green, teal, blue, indigo, violet, purple, pink

Base color 的 foreground/background 使用灰系 OKLCH 值（色度接近 0）。
Accent color 仅改变 primary 系列颜色，其余复用 zinc 的灰系值。

## 已有主题速查

| 主题 | Primary (light) | Primary (dark) |
|---|---|---|
| zinc | `oklch(0.21 0.006 285.885)` | `oklch(0.92 0.004 286.32)` |
| red | `oklch(0.577 0.245 27.325)` | `oklch(0.704 0.191 22.216)` |
| rose | `oklch(0.586 0.253 17.585)` | `oklch(0.514 0.222 16.935)` |
| orange | `oklch(0.646 0.222 41.116)` | `oklch(0.554 0.195 38.402)` |
| yellow | `oklch(0.795 0.184 86.047)` | `oklch(0.681 0.162 75.834)` |
| green | `oklch(0.596 0.145 163.225)` | `oklch(0.508 0.118 165.612)` |
| teal | `oklch(0.6 0.118 184.704)` | `oklch(0.511 0.096 186.391)` |
| blue | `oklch(0.488 0.243 264.376)` | `oklch(0.424 0.199 265.638)` |
| indigo | `oklch(0.511 0.262 276.966)` | `oklch(0.432 0.232 279.738)` |
| violet | `oklch(0.541 0.281 293.009)` | `oklch(0.457 0.24 292.771)` |
| purple | `oklch(0.558 0.288 302.321)` | `oklch(0.457 0.24 302.321)` |
| pink | `oklch(0.592 0.249 0.584)` | `oklch(0.487 0.203 358.78)` |
