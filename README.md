# shadcn-swift

将 [shadcn/ui](https://github.com/shadcn-ui/ui) 设计系统移植到 Apple 平台 (iOS / macOS)，使用 SwiftUI 实现。

> **Phase 1 POC** — 已实现 `Button` + `Card` 两个控件，验证了 OKLCH 色彩 → DesignToken → 主题系统 → 自定义样式 的完整链路。

## 设计理念

shadcn/ui 的核心价值不是"黑盒组件库"，而是：

| 核心理念 | Web (shadcn/ui) | Swift (shadcn-swift) |
|---|---|---|
| 源码可见可改 | 复制 `.tsx` 到项目 | 复制 `.swift` 到项目 |
| 主题系统 | CSS 变量 (oklch) | `DesignToken` + `Environment` |
| 变体模式 | `cva` + tailwind | `enum` + computed properties |
| 自定义样式 | `className` prop + `cn()` | `cornerRadius`/`borderWidth` 等 first-class 参数 + `customStyle` 闭包 |
| Light / Dark | CSS `:root` / `.dark` | `@Environment(\.colorScheme)` 自动切换 |

## 快速开始

```swift
// 1. 引入
import ShadcnSwiftUI

// 2. 设置主题
ContentView()
    .shadcnTheme(Themes.blue)

// 3. 使用组件

// Button
Button("Click") { }
    .shadcnButton(variant: .outline, size: .sm)

// Button 自定义圆角（first-class 参数，替换内部默认值）
Button("Pill") { }
    .shadcnButton(variant: .default, cornerRadius: 999)

// Button 自定义样式（customStyle 闭包，灵活扩展）
Button("Glow") { }
    .shadcnButton(variant: .default) { label in
        AnyView(label.shadow(color: .blue.opacity(0.5), radius: 8, y: 4))
    }

// Card
Card {
    CardHeader {
        CardTitle("Title")
        CardDescription("Description")
    }
    CardContent {
        Text("Content")
    }
    CardFooter {
        Button("Action") { }.shadcnButton(size: .sm)
    }
}

// Card 自定义（first-class 参数，无副作用）
Card(cornerRadius: 24, borderWidth: 2, borderColor: .blue) {
    // ...
}
```

## 组件清单

| 组件 | 状态 | Variants | First-class 自定义 |
|---|---|---|---|
| Button | ✅ | 6 variants, 8 sizes | `cornerRadius` |
| Card | ✅ | 7 sub-components | `cornerRadius`, `borderWidth`, `borderColor` |

## 内置主题

```swift
Themes.zinc      // 锌灰（默认）
Themes.neutral   // 中性灰
Themes.stone     // 石灰
Themes.rose      // 玫红
Themes.orange    // 橙色
Themes.green     // 绿色
Themes.blue      // 蓝色
Themes.violet    // 紫罗兰
```

## 两种自定义方式

### First-class 参数（推荐常用样式）

直接传入 init，**替换**内部默认值，无副作用：

```swift
Card(cornerRadius: 24, borderWidth: 2, borderColor: .blue) { ... }
Button("Btn") { }.shadcnButton(cornerRadius: 999)
```

### customStyle 闭包（高级扩展）

在最外层追加 modifier，用于特效等：

```swift
.shadcnButton(variant: .default) { label in
    AnyView(label.shadow(radius: 8))
}
```

## 目录结构

```
shadcn-swift/
├── Package.swift
├── Sources/ShadcnSwiftUI/
│   ├── Theme/              # 主题系统
│   │   ├── DesignToken.swift
│   │   ├── Theme.swift
│   │   ├── Themes.swift
│   │   └── ThemeEnvironment.swift
│   ├── Utils/
│   │   └── Color+OKLCH.swift   # OKLCH 色彩解析
│   └── Components/
│       ├── Button/Button.swift
│       └── Card/Card.swift
├── docs/
│   ├── design-tokens.md
│   ├── migration-guide.md
│   ├── custom-style.md
│   └── component-template.swift
└── ShadcnSwift/            # Demo App (Xcode)
    └── ContentView.swift
```

## 文档

| 文档 | 内容 |
|---|---|
| [design-tokens.md](shadcn-swift/docs/design-tokens.md) | CSS 变量 → DesignToken 映射表 |
| [migration-guide.md](shadcn-swift/docs/migration-guide.md) | 组件迁移 8 步 SOP |
| [custom-style.md](shadcn-swift/docs/custom-style.md) | 自定义样式 API 指南 |
| [component-template.swift](shadcn-swift/docs/component-template.swift) | 组件源码模板（复制即用） |

## 平台要求

- iOS 18+
- macOS 15+
- Swift 6
