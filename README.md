# shadcn-swift

将 [shadcn/ui](https://github.com/shadcn-ui/ui) 设计系统移植到 Apple 平台 (iOS / macOS)，使用 SwiftUI 实现。

> **当前进度** — 已移植 **15 个组件**，覆盖基础表单、反馈、数据展示等常见场景。主题系统（8 套内置主题 + OKLCH 色彩空间）和自定义样式 API（first-class 参数 + customStyle 闭包）已就绪。

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

// 3. 使用组件 — Button
Button("Click") { }
    .shadcnButton(variant: .outline, size: .sm)

Button("Pill") { }
    .shadcnButton(variant: .default, cornerRadius: 999)

// Card
Card {
    CardHeader {
        CardTitle("Title")
        CardDescription("Description")
    }
    CardContent { Text("Content") }
    CardFooter {
        Button("Action") { }.shadcnButton(size: .sm)
    }
}

// Badge
Badge(variant: .destructive) { Text("Deleted") }

// Input + Label
ShadcnLabel("Email", required: true)
Input("Enter email", text: $email)

// Switch / Checkbox / RadioGroup
Toggle("", isOn: $enabled).toggleStyle(.shadcnSwitch)
Checkbox(isChecked: $checked)
RadioGroup(selection: $selected) {
    RadioItem("Option A", value: "a")
    RadioItem("Option B", value: "b")
}

// Progress / Skeleton
Progress(value: 0.6)
Skeleton().frame(width: 200, height: 16)

// Alert / Avatar / Separator / Toggle / Textarea
Alert(variant: .destructive) {
    AlertTitle("Error")
    AlertDescription("Something went wrong.")
}
Avatar(size: .lg) { AvatarFallback(initials: "JD") }
Separator()
ShadcnToggle(isPressed: $bold) { Image(systemName: "bold") }
Textarea("Write something…", text: $text, minHeight: 80)
```

## 组件清单

| 组件 | 状态 | Variants / 子组件 | 自定义参数 |
|---|---|---|---|
| Button | ✅ | 6 variants, 8 sizes | `cornerRadius`, `customStyle` |
| Card | ✅ | 7 个子组件 (Header/Title/Description/Action/Content/Footer) | `cornerRadius`, `borderWidth`, `borderColor`, `customStyle` |
| Badge | ✅ | 6 variants (default/secondary/destructive/outline/ghost/link) | `customStyle` |
| Input | ✅ | — | `isInvalid` |
| Textarea | ✅ | — | `minHeight` |
| Label | ✅ | — | `required` |
| Switch | ✅ | 2 sizes (default/sm), ToggleStyle | — |
| Checkbox | ✅ | 16×16, checkmark icon | — |
| RadioGroup | ✅ | RadioGroup + RadioItem | — |
| Progress | ✅ | determinate / indeterminate | `height` |
| Skeleton | ✅ | 脉冲动画 | — |
| Separator | ✅ | horizontal / vertical | `decorative` |
| Alert | ✅ | default / destructive, 4 个子组件 (Title/Description/Action) | — |
| Avatar | ✅ | 3 sizes, 6 个子组件 (Image/Fallback/Badge/Group/GroupCount) | — |
| Toggle | ✅ | 2 variants (default/outline), 3 sizes | — |

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
│       ├── Alert/Alert.swift
│       ├── Avatar/Avatar.swift
│       ├── Badge/Badge.swift
│       ├── Button/Button.swift
│       ├── Card/Card.swift
│       ├── Checkbox/Checkbox.swift
│       ├── Input/Input.swift
│       ├── Label/Label.swift
│       ├── Progress/Progress.swift
│       ├── RadioGroup/RadioGroup.swift
│       ├── Separator/Separator.swift
│       ├── Skeleton/Skeleton.swift
│       ├── Switch/Switch.swift
│       ├── Textarea/Textarea.swift
│       └── Toggle/Toggle.swift
├── docs/
│   ├── design-tokens.md
│   ├── migration-guide.md
│   ├── custom-style.md
│   ├── component-template.swift
│   ├── p0-components-plan.md
│   └── p1-p2-p3-components.md
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
| [p0-components-plan.md](shadcn-swift/docs/p0-components-plan.md) | P0 组件（Badge/Input/Switch/Separator/Avatar）移植规格 |
| [p1-p2-p3-components.md](shadcn-swift/docs/p1-p2-p3-components.md) | P1/P2/P3 待移植组件清单 |

## 平台要求

- iOS 18+
- macOS 15+
- Swift 6
