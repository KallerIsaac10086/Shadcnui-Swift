# Custom Style API

对应 shadcn/ui 的 `className` prop — 用户自定义覆盖样式的能力。

## 核心原理

```
shadcn/ui (React):
  cn(componentDefaults, userClassName)
  → twMerge 消除冲突，userClassName 覆盖默认

shadcn-swift (SwiftUI):
  组件先应用默认样式
  → customStyle 闭包在最外层追加 modifier
  → SwiftUI 自然规则：外层 modifier 覆盖内层同属性
```

## Button

### 基础用法

```swift
// 无自定义（向后兼容）
Button("Click") { }
    .shadcnButton(variant: .outline, size: .sm)
```

### 自定义样式

```swift
// Pill 圆角按钮
Button("Pill") { }
    .shadcnButton(variant: .default) { label in
        AnyView(label.cornerRadius(999))
    }

// 全宽按钮
Button("Wide") { }
    .shadcnButton(variant: .outline) { label in
        AnyView(label.frame(maxWidth: .infinity))
    }

// 发光按钮
Button("Glow") { }
    .shadcnButton(variant: .default) { label in
        AnyView(label.shadow(color: .blue.opacity(0.5), radius: 8, y: 4))
    }

// 多个自定义组合
Button("Fancy") { }
    .shadcnButton(variant: .destructive, size: .lg) { label in
        AnyView(
            label
                .cornerRadius(999)
                .shadow(radius: 8)
        )
    }
```

### 使用 ShadcnButton wrapper

```swift
ShadcnButton("Delete", variant: .destructive) {
    // action
} customStyle: { label in
    AnyView(label.cornerRadius(20).frame(maxWidth: .infinity))
}
```

## Card

### Card 容器

```swift
Card(customStyle: { card in
    AnyView(
        card
            .background(Color.blue.opacity(0.08))
            .cornerRadius(24)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(Color.blue.opacity(0.3), lineWidth: 2)
            )
    )
}) {
    // card content
}
```

### CardTitle

```swift
CardTitle("Premium Plan", customStyle: { title in
    AnyView(
        title
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.blue)
    )
})
```

### CardDescription

```swift
CardDescription("Description text", customStyle: { desc in
    AnyView(desc.font(.system(size: 12)))
})
```

### CardHeader / CardContent / CardFooter / CardAction

```swift
CardHeader(customStyle: { header in
    AnyView(header.padding(.top, 32))
}) {
    // header content
}

CardFooter(customStyle: { footer in
    AnyView(footer.background(Color.gray.opacity(0.05)))
}) {
    // footer actions
}
```

## 自定义效果对照

| 需求 | shadcn/ui className | shadcn-swift customStyle |
|---|---|---|
| 更大圆角 | `"rounded-2xl"` | `{ AnyView($0.cornerRadius(16)) }` |
| 全宽 | `"w-full"` | `{ AnyView($0.frame(maxWidth: .infinity)) }` |
| 阴影 | `"shadow-lg"` | `{ AnyView($0.shadow(radius: 10, y: 4)) }` |
| 改字号 | `"text-lg"` | `{ AnyView($0.font(.title3)) }` |
| 改颜色 | `"text-red-500"` | `{ AnyView($0.foregroundColor(.red)) }` |
| 改背景 | `"bg-red-500"` | ⚠️ 见下方说明 |
| 内边距 | `"px-8"` | `{ AnyView($0.padding(.horizontal, 32)) }` |

## ⚠️ 注意事项

### `background` 是叠加而非替换

SwiftUI 的 `.background()` 在视图背面**添加图层**，不像 CSS 那样替换 `background-color` 属性。这意味着：

```swift
// ❌ 不会替换默认背景（外层的 background 被内层覆盖）
.shadcnButton(variant: .default) { label in
    AnyView(label.background(Color.red))
}

// ✅ 如需可见的颜色效果，建议用 overlay / shadow / tint
.shadcnButton(variant: .default) { label in
    AnyView(label.shadow(color: .red.opacity(0.5), radius: 8))
}
```

### 圆角覆盖

`.cornerRadius()` 在外层比内层的相同 clip 更"激进"时才生效：

```swift
// ✅ 999 > 10（默认值），生效
.shadcnButton { AnyView($0.cornerRadius(999)) }

// ❌ 5 < 10（默认值），不生效（内层已经裁掉了更多）
.shadcnButton { AnyView($0.cornerRadius(5)) }
```

### 字号覆盖

`customStyle` 应用在最外层，可以覆盖内层的 `font`：

```swift
CardTitle("Title", customStyle: { title in
    AnyView(title.font(.largeTitle))  // ✅ 覆盖默认 16pt
})
```

## 实现新组件时的 customStyle Pattern

```swift
public struct MyComponent<Content: View>: View {
    // ... existing properties
    let customStyle: ((AnyView) -> AnyView)?

    public init(
        // ... existing params
        customStyle: ((AnyView) -> AnyView)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        // ...
        self.customStyle = customStyle
    }

    public var body: some View {
        // 1. 用 AnyView 包裹所有默认样式
        let base = AnyView(
            content()
                .font(.system(size: 14))
                .background(token.background)
                // ... 所有默认 modifier
        )

        // 2. 如果有自定义样式，在外层应用
        if let style = customStyle {
            return style(base)
        }
        return base
    }
}
```
