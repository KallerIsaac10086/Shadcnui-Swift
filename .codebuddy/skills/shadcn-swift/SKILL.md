---
name: shadcn-swift
description: >-
  shadcn-swift 组件库开发技能。用于新增组件、修改主题系统、更新 Demo App、
  代码审查等 shadcn-swift 项目的所有开发任务。
  包含组件编写规范、DesignToken 体系、自定义样式 API、迁移指南等。
  当用户要求新增 SwiftUI 组件、修改主题颜色、更新 Demo App、
  或进行 shadcn/ui → SwiftUI 移植时触发此技能。
---

# shadcn-swift 组件库开发指南

## 项目概述

shadcn-swift 是将 shadcn/ui 设计系统移植到 Apple 平台（iOS 18+ / macOS 15+）的 SwiftUI 组件库。
源码可见、可复制、可定制。当前包含 56 个组件、14 套主题、33 个 DesignToken。

## 核心架构

### 目录结构

```
/workspace/
├── Package.swift                          # SPM 清单（根目录）
├── shadcn-swift/
│   ├── Sources/ShadcnSwiftUI/
│   │   ├── Theme/                         # 主题系统
│   │   │   ├── DesignToken.swift          # 33 个语义 token
│   │   │   ├── Theme.swift                # 主题容器 (name + light + dark)
│   │   │   ├── Themes.swift               # 14 套内置主题
│   │   │   └── ThemeEnvironment.swift     # @Environment(\.shadcnToken)
│   │   ├── Utils/
│   │   │   └── Color+OKLCH.swift          # OKLCH 色彩解析
│   │   └── Components/                    # 56 个组件目录
│   └── Tests/
├── ShadcnSwift/                           # Demo App (Xcode)
│   └── ShadcnSwift/
│       ├── ContentView.swift              # 全组件交互式预览
│       └── ShadcnSwiftApp.swift
└── docs/                                  # 设计文档 + 迁移计划
```

### 主题系统

通过 `@Environment(\.shadcnToken)` 注入，`.shadcnTheme(Themes.blue)` 在根 View 设置。

DesignToken 包含 33 个字段：
- 基础色: background, foreground
- Card: card, cardForeground
- Popover: popover, popoverForeground
- Primary: primary, primaryForeground
- Secondary: secondary, secondaryForeground
- Muted: muted, mutedForeground
- Accent: accent, accentForeground
- Destructive: destructive, destructiveForeground
- Sidebar: sidebar, sidebarForeground, sidebarPrimary, sidebarPrimaryForeground, sidebarAccent, sidebarAccentForeground, sidebarBorder, sidebarRing
- Chart: chart1~chart5
- Border: border, input, ring
- Radius: radius (CGFloat)

### 自定义样式 API

两种方式互补：
1. **First-class 参数** — init 参数直接替换内部默认值（cornerRadius, borderWidth, borderColor 等）
2. **customStyle 闭包** — `((AnyView) -> AnyView)?` 在最外层追加 modifier

## 组件编写规范

### 必须遵守的规则

1. **文件位置**: `shadcn-swift/Sources/ShadcnSwiftUI/Components/{ComponentName}/{ComponentName}.swift`
2. **导入**: 仅 `import SwiftUI`，不导入其他
3. **可见性**: 所有 `struct`、`enum`、`init` 必须是 `public`
4. **枚举**: 所有 variant/size enum 必须加 `Sendable`
5. **主题访问**: `@Environment(\.shadcnToken) private var token`
6. **禁用状态**: `@Environment(\.isEnabled) private var isEnabled` + `.opacity(isEnabled ? 1 : 0.5)`
7. **动画**: 统一使用 `.easeInOut(duration: 0.15)` 或 `.easeInOut(duration: 0.2)`
8. **文档注释**: `///` 注释说明对应 shadcn/ui 组件 + Usage 示例
9. **String 简写**: 为常见组件提供 `init(_ title: String, ...)` 便捷构造器

### 代码模板

```swift
import SwiftUI

// MARK: - Variant

public enum ComponentVariant: String, CaseIterable, Sendable {
    case `default`
    case secondary
    case destructive
}

// MARK: - Component

/// Description. Corresponds to `<Component>` in shadcn/ui.
///
/// Usage:
/// ```swift
/// Component("Text") { action() }
/// ```
public struct Component<Label: View>: View {
    @Environment(\.shadcnToken) private var token
    @Environment(\.isEnabled) private var isEnabled

    let variant: ComponentVariant
    @ViewBuilder let label: () -> Label

    public init(
        variant: ComponentVariant = .default,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.variant = variant
        self.label = label
    }

    public var body: some View {
        label()
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(token.foreground)
            .opacity(isEnabled ? 1 : 0.5)
    }
}

// MARK: - String shorthand

public extension Component where Label == Text {
    init(_ title: String, variant: ComponentVariant = .default) {
        self.init(variant: variant) { Text(title) }
    }
}
```

### 弹窗组件规则

弹窗类组件（Dialog/Sheet/Drawer/AlertDialog/Select/Combobox）必须使用 `.fullScreenCover` + `.presentationBackground(.clear)` 实现全屏覆盖，不能用 `.overlay`（会被限制在触发元素尺寸内）。

```swift
content
    .fullScreenCover(isPresented: $isPresented) {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            // dialog content
        }
        .presentationBackground(.clear)
    }
```

### Environment 传递模式

需要父子通信的组件（如 Tabs、Accordion、Select）使用 Environment + Action struct 模式：

```swift
struct SelectAction: Sendable {
    let select: @Sendable (AnyHashable) -> Void
}

extension EnvironmentValues {
    var selectAction: SelectAction { ... }
}

// 父组件注入
.environment(\.selectAction, SelectAction { selection = $0 })

// 子组件调用
Button { selectAction.select(value) } label: { ... }
```

## 新增组件流程

1. 在 `Components/` 下创建 `{Name}/{Name}.swift`
2. 按模板编写组件代码
3. 如需 Environment 通信，定义 EnvironmentKey + Action struct
4. 在 Demo App `ContentView.swift` 的 `ComponentList` 中添加:
   - `@State` 变量（如需交互状态）
   - LazyVGrid 中添加 `section_xxx` 调用
   - 底部添加 `@ViewBuilder private var section_xxx` 实现
5. 编译验证无错误
6. 提交推送

## 新增主题流程

1. 在 `Themes.swift` 中添加 `public static let themeName = Theme(...)`
2. Light + Dark 两套 DesignToken，颜色使用 `.oklch("oklch(L C H)")` 格式
3. 在 Demo App 的 `ThemePicker` 和 `currentTheme` switch 中添加新主题
4. 如需 preset 编解码支持，更新 `themeIndex` / `themeFromIndex` 字典

## DesignToken 扩展流程

1. 在 `DesignToken.swift` 中添加新字段（带默认值以保持向后兼容）
2. 如需移除默认值，更新所有 Theme 的初始化
3. 更新 `design-tokens.md` 文档
4. 更新使用该 token 的组件

## 参考资源

- 组件审计报告: `docs/component-audit.md`
- P0 组件规格: `docs/p0-components-plan.md`
- P1/P2/P3 清单: `docs/p1-p2-p3-components.md`
- Token 对照表: `docs/design-tokens.md`
- 迁移 SOP: `docs/migration-guide.md`
- 自定义样式指南: `docs/custom-style.md`
- 组件模板: `docs/component-template.swift`
- shadcn/ui 原始源码: `shadcnui/apps/v4/registry/bases/radix/ui/`
