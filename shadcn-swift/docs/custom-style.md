# Custom Style API

对应 shadcn/ui 的 `className` prop — 用户自定义覆盖组件样式的能力。

## 两种方式

| 方式 | 适用场景 | 效果 |
|---|---|---|
| **First-class 参数** | 圆角、边框等常用样式 | **替换**内部默认值，无副作用 |
| **customStyle 闭包** | 特效、复杂组合等高级需求 | **追加**在默认样式外层 |

---

## First-class 参数（推荐常用样式）

直接传入 init，**替换**内部默认值，不会产生双层叠加。

### Button — `cornerRadius`

```swift
// 默认圆角
Button("Default") { }
    .shadcnButton(variant: .default)

// Pill 圆角
Button("Pill") { }
    .shadcnButton(variant: .default, cornerRadius: 999)

// 方角（cornerRadius: 0 — 内部直接用 0 替换默认值）
Button("Square") { }
    .shadcnButton(variant: .outline, cornerRadius: 0)
```

### Card — `cornerRadius` / `borderWidth` / `borderColor`

```swift
// 默认
Card { ... }

// 大圆角 + 粗边框
Card(cornerRadius: 24, borderWidth: 2) { ... }

// 大圆角 + 彩色边框
Card(cornerRadius: 20, borderColor: .blue) { ... }

// 方角 + 无边框
Card(cornerRadius: 0, borderWidth: 0) { ... }

// 全部自定义
Card(cornerRadius: 16, borderWidth: 3, borderColor: currentTheme.light.primary) { ... }
```

---

## customStyle 闭包（高级扩展）

回调接收 `AnyView`（已应用默认样式），用户在外层**追加** modifier。

### 核心原理

```
shadcn/ui (React):
  cn(componentDefaults, userClassName)
  → twMerge 消除冲突，userClassName 覆盖默认

shadcn-swift (SwiftUI):
  组件先应用默认样式 → customStyle 闭包在外层追加 modifier
  → SwiftUI 自然规则：外层 modifier 覆盖内层同属性
```

### Button

```swift
// 全宽
Button("Wide") { }
    .shadcnButton(variant: .outline) { label in
        AnyView(label.frame(maxWidth: .infinity))
    }

// 发光阴影
Button("Glow") { }
    .shadcnButton(variant: .default) { label in
        AnyView(label.shadow(color: .blue.opacity(0.5), radius: 8, y: 4))
    }

// 复合自定义（first-class + customStyle）
Button("Fancy") { }
    .shadcnButton(variant: .destructive, cornerRadius: 999) { label in
        AnyView(label.shadow(radius: 8).frame(maxWidth: .infinity))
    }
```

### Card（全部 7 个子组件）

```swift
// Card 容器
Card(cornerRadius: 24, customStyle: { card in
    AnyView(card.shadow(radius: 8))
}) { ... }

// CardTitle 字体/颜色
CardTitle("Premium", customStyle: { title in
    AnyView(title.font(.largeTitle).foregroundColor(.blue))
})

// CardDescription
CardDescription("Text", customStyle: { desc in
    AnyView(desc.font(.system(size: 12)))
})

// CardHeader / CardContent / CardFooter / CardAction
CardHeader(customStyle: { header in
    AnyView(header.padding(.top, 32))
}) { ... }
```

---

## 效果对照表

| 需求 | First-class 参数 | customStyle |
|---|---|---|
| 修改圆角 | `cornerRadius: 999` ✅ | `{ AnyView($0.cornerRadius(999)) }` |
| 修改边框 | `borderWidth: 2, borderColor: .blue` ✅ | `{ AnyView($0.overlay(...)) }` |
| 全宽 | — | `{ AnyView($0.frame(maxWidth: .infinity)) }` |
| 阴影 | — | `{ AnyView($0.shadow(radius: 8)) }` |
| 改字号 | — | `{ AnyView($0.font(.title)) }` |
| 改颜色 | — | `{ AnyView($0.foregroundColor(.red)) }` |

---

## ⚠️ 注意事项

### First-class 参数 vs customStyle 的选择

- **圆角 / 边框**：优先用 first-class 参数。它们直接**替换**内部 clip/border，不会产生双层叠加。
- **阴影 / frame / 颜色**：用 customStyle。它们在外层**追加**，不影响内层结构。
- **可以混用**：first-class 参数处理结构（clip/border），customStyle 处理装饰（shadow/frame）。

### `background` 是叠加而非替换

SwiftUI 的 `.background()` 在视图背面**添加图层**，不像 CSS 替换 `background-color`。自定义背景色建议用 first-class 参数的 `borderColor` 或其他途径实现。

### 圆角覆盖规则

`.cornerRadius(N)` 在外层比内层 clip 更"大"时才生效（大 = 更圆）。推荐使用 first-class 参数直接控制内部 clip。

---

## 实现新组件的 custom Style Pattern

```swift
public struct MyComponent<Content: View>: View {
    // ── First-class params（替换内部默认值） ──
    let cornerRadius: CGFloat?
    let borderWidth: CGFloat?

    // ── customStyle（外层扩展） ──
    let customStyle: ((AnyView) -> AnyView)?

    public init(
        cornerRadius: CGFloat? = nil,
        borderWidth: CGFloat? = nil,
        customStyle: ((AnyView) -> AnyView)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) { ... }

    public var body: some View {
        // 1. 用 first-class 参数（或默认值）构建内部样式
        let radius = cornerRadius ?? 10
        let base = AnyView(
            content()
                .background(token.background)
                .clipShape(RoundedRectangle(cornerRadius: radius))
                .overlay(RoundedRectangle(cornerRadius: radius)
                    .strokeBorder(token.border, lineWidth: borderWidth ?? 1))
        )

        // 2. customStyle 在外层追加
        if let style = customStyle {
            return style(base)
        }
        return base
    }
}
```
