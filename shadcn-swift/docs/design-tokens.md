# Design Token 对照表

shadcn/ui 的 CSS 变量到 `shadcn-swift` 的 `DesignToken` 映射。

## Token 定义

```swift
public struct DesignToken: Sendable {
    public let background: Color
    public let foreground: Color
    public let card: Color
    public let cardForeground: Color
    public let popover: Color
    public let popoverForeground: Color
    public let primary: Color
    public let primaryForeground: Color
    public let secondary: Color
    public let secondaryForeground: Color
    public let muted: Color
    public let mutedForeground: Color
    public let accent: Color
    public let accentForeground: Color
    public let destructive: Color
    public let border: Color
    public let input: Color
    public let ring: Color
    public let radius: CGFloat
}
```

## CSS Variable → Swift Token

| shadcn CSS Variable | Swift Token | 语义 |
|---|---|---|
| `--background` | `.background` | 页面背景色 |
| `--foreground` | `.foreground` | 主文字色 |
| `--card` | `.card` | 卡片背景色 |
| `--card-foreground` | `.cardForeground` | 卡片文字色 |
| `--popover` | `.popover` | 弹出层背景色 |
| `--popover-foreground` | `.popoverForeground` | 弹出层文字色 |
| `--primary` | `.primary` | 主强调色 |
| `--primary-foreground` | `.primaryForeground` | 主强调色上的文字 |
| `--secondary` | `.secondary` | 次要背景色 |
| `--secondary-foreground` | `.secondaryForeground` | 次要背景上的文字 |
| `--muted` | `.muted` | 静默/弱化背景 |
| `--muted-foreground` | `.mutedForeground` | 辅助/弱化文字 |
| `--accent` | `.accent` | 强调背景 |
| `--accent-foreground` | `.accentForeground` | 强调背景上的文字 |
| `--destructive` | `.destructive` | 危险/删除操作色 |
| `--border` | `.border` | 边框色 |
| `--input` | `.input` | 输入框边框色 |
| `--ring` | `.ring` | 焦点环颜色 |
| `--radius` | `.radius` | 全局圆角 (rem → pt, 0.625rem ≈ 10pt) |

## 颜色格式

shadcn/ui 使用 **oklch** 色彩空间。Swift 端通过 `Color(oklchString:)` 解析：

```swift
// CSS: oklch(0.205 0 0)
// Swift:
.primary = Color(oklchString: "oklch(0.205 0 0)")

// 也可以直接传 raw string
.primary = .oklch("oklch(0.205 0 0)")
```

支持的格式：
- `oklch(L C H)` — 无透明度
- `oklch(L C H / A)` — 带透明度（小数）
- `oklch(L C H / A%)` — 带透明度（百分比）

## 内置主题

| 主题 | 类型 | 说明 |
|---|---|---|
| `Themes.neutral` | Base | 中性灰 |
| `Themes.zinc` | Base | 锌灰（默认） |
| `Themes.stone` | Base | 石灰色 |
| `Themes.rose` | Accent | 玫红 |
| `Themes.orange` | Accent | 橙色 |
| `Themes.green` | Accent | 绿色 |
| `Themes.blue` | Accent | 蓝色 |
| `Themes.violet` | Accent | 紫罗兰 |

## 使用 Token

在组件内部通过 `@Environment` 读取：

```swift
@Environment(\.shadcnToken) private var token

// 使用
view
    .background(token.background)
    .foregroundColor(token.foreground)
    .clipShape(RoundedRectangle(cornerRadius: token.radius))
```

## 添加新主题

```swift
extension Themes {
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
}
```
