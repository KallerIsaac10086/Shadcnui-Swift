# 组件迁移指南

从 shadcn/ui (React/TypeScript) 迁移组件到 shadcn-swift (SwiftUI) 的标准操作流程。

## 概念映射

| shadcn/ui (Web) | shadcn-swift (Apple) |
|---|---|
| React Function Component | SwiftUI `View` struct |
| `className` prop | `customStyle: ((AnyView) -> AnyView)?` init param |
| `cn(defaultClasses, className)` | 默认 modifier → `customStyle` 闭包（自然覆盖） |
| `cva` (class-variance-authority) | Swift `enum` + properties |
| `data-slot` 属性 | 无需（SwiftUI View 类型即身份） |
| CSS `:root` / `.dark` | `@Environment(\.shadcnToken)` + `@Environment(\.colorScheme)` |
| `asChild` (Radix Slot) | `@ViewBuilder` label 参数 |
| `tailwind-merge` | SwiftUI modifier 叠加顺序 = 自动覆盖 |

## SOP：8 步迁移

### Step 1：分析源组件

阅读 shadcn/ui 源码，记录：
- Props / 参数列表
- Variant 枚举（variant / size 等）
- 子组件结构（如 Card → CardHeader, CardTitle...）
- 使用的 design token（`--background`, `--primary` 等）
- 行为逻辑（hover, press, disabled 状态）

```bash
# 源文件位置
shadcnui/apps/v4/registry/bases/radix/ui/<component>.tsx
```

### Step 2：定义 Variant Enum

```swift
// Web: cva variants
// Swift: enum + CaseIterable + Sendable

public enum ComponentVariant: String, CaseIterable, Sendable {
    case `default`
    case outline
    case ghost
}

public enum ComponentSize: String, CaseIterable, Sendable {
    case `default`
    case sm
    case lg
}
```

### Step 3：实现 View / ButtonStyle

根据组件类型选择：

| Web 组件类型 | Swift 实现方式 |
|---|---|
| 无交互容器（Card, Badge） | `struct XxxView: View` |
| 按钮类（Button, Toggle） | `struct XxxStyle: ButtonStyle` |
| 输入类（Input, Textarea） | `struct XxxView: View` + `@Binding` |

### Step 4：映射 Design Token

将 CSS 变量替换为 token 属性：

```swift
// Web: className="bg-primary text-primary-foreground"
// Swift:
@Environment(\.shadcnToken) private var token

view
    .background(token.primary)
    .foregroundColor(token.primaryForeground)
```

### Step 5：实现样式计算

```swift
// Web: cva 的 compoundVariants / defaultVariants
// Swift: computed properties

private var backgroundColor: Color {
    switch variant {
    case .default:  return token.primary
    case .outline:  return .clear
    case .ghost:    return .clear
    }
}

private var cornerRadius: CGFloat {
    size == .icon ? height / 2 : token.radius
}
```

### Step 6：实现状态处理

```swift
// Web: hover:bg-primary/90 disabled:opacity-50
// Swift: @Environment + configuration.isPressed

@Environment(\.isEnabled) private var isEnabled

private func backgroundColor(isPressed: Bool) -> Color {
    var color = variant == .default ? token.primary : .clear
    if isPressed { color = color.opacity(0.8) }
    return color
}

// 应用
.opacity(isEnabled ? 1.0 : 0.5)
.scaleEffect(configuration.isPressed ? 0.97 : 1.0)
```

### Step 7：添加 `customStyle` 支持

```swift
public struct MyComponent<Content: View>: View {
    let customStyle: ((AnyView) -> AnyView)?

    public var body: some View {
        let base = AnyView(
            content()
                .background(token.background)
                .clipShape(RoundedRectangle(cornerRadius: token.radius))
        )
        if let style = customStyle {
            return style(base)
        }
        return base
    }
}
```

### Step 8：提供便捷 Modifier

```swift
public extension View {
    func shadcnMyComponent(
        variant: MyVariant = .default,
        customStyle: ((AnyView) -> AnyView)? = nil
    ) -> some View {
        self.modifier(MyModifier(variant: variant, customStyle: customStyle))
    }
}
```

## 完整迁移示例：Badge

### 源 (React)

```tsx
function Badge({ className, variant = "default", ...props }) {
  return (
    <div
      data-slot="badge"
      className={cn(badgeVariants({ variant }), className)}
      {...props}
    />
  )
}

const badgeVariants = cva(
  "inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-semibold",
  {
    variants: {
      variant: {
        default: "bg-primary text-primary-foreground",
        secondary: "bg-secondary text-secondary-foreground",
        destructive: "bg-destructive text-white",
        outline: "text-foreground border",
      },
    },
  }
)
```

### 目标 (Swift)

```swift
public enum BadgeVariant: String, CaseIterable, Sendable {
    case `default`, secondary, destructive, outline
}

public struct Badge<Label: View>: View {
    @Environment(\.shadcnToken) private var token
    let variant: BadgeVariant
    let label: () -> Label
    let customStyle: ((AnyView) -> AnyView)?

    public var body: some View {
        let base = AnyView(
            label()
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 10)
                .padding(.vertical, 2)
                .background(bgColor)
                .foregroundColor(fgColor)
                .clipShape(Capsule())
                .overlay(
                    variant == .outline
                        ? Capsule().strokeBorder(token.border, lineWidth: 1)
                        : nil
                )
        )
        if let style = customStyle {
            return style(base)
        }
        return base
    }

    private var bgColor: Color {
        switch variant {
        case .default:     return token.primary
        case .secondary:   return token.secondary
        case .destructive: return token.destructive
        case .outline:     return .clear
        }
    }

    private var fgColor: Color {
        switch variant {
        case .default:     return token.primaryForeground
        case .secondary:   return token.secondaryForeground
        case .destructive: return .white
        case .outline:     return token.foreground
        }
    }
}
```

## 常见陷阱

| 问题 | 说明 | 对策 |
|---|---|---|
| `background` 是叠加不是替换 | SwiftUI `.background()` 添加图层，不像 CSS 替换属性 | 如需替换，在 `customStyle` 中用 `overlay` 替代 |
| `font` 继承规则不同 | 子 View 的内部 font 不会被父级覆盖 | 通过 `customStyle` 在组件内部介入 |
| `hover` 无直接等价 | iOS 无 hover 态，macOS 有 `onHover` | 分别处理 `#if os(macOS)` |
| `transition-all 150ms` | CSS transition | `.animation(.easeInOut(duration: 0.15), value:)` |
| `asChild` 多态 | React Slot pattern | SwiftUI `@ViewBuilder` label 参数 |
