# shadcn/ui → Apple 平台移植计划

> 阶段一（POC）已完成。阶段二（P0+P1 表单组件）已完成。当前推进阶段二剩余项。

## 当前状态

| 阶段 | 状态 | 内容 |
|---|---|---|
| Step 1-7 (POC) | ✅ 已完成 | Button + Card + OKLCH + Theme + Demo App |
| P0 表单组件 | ✅ 已完成 | Badge, Input, Switch, Separator, Avatar |
| P1 表单与反馈 | ✅ 已完成 | Alert, Textarea, Label, Checkbox, RadioGroup, Progress, Skeleton, Toggle |
| P1 剩余 | 🔲 待移植 | Slider, Collapsible, NativeSelect, Direction, Kbd |
| P2 浮层与导航 | 🔲 待移植 | Dialog, Sheet, Tooltip, Popover, HoverCard, AlertDialog, Tabs, Breadcrumb |
| P3 复杂控件 | 🔲 待移植 | DropdownMenu, Select, Combobox, Command, Calendar, Chart, Table 等 |

已移植 **15/63** 组件（23.8%）。

---

## 二、技术选型

| 层级 | shadcn/ui (Web) | shadcn-swift (Apple) | 说明 |
|---|---|---|---|
| 框架 | React 19 | **SwiftUI** (iOS 17+ / macOS 14+) | 声明式 UI，与 React 心智模型接近 |
| 样式系统 | Tailwind CSS v4 + CSS 变量 | **DesignToken + ViewModifier** | 用 Swift 的 `struct` + `Environment` 替代 CSS 变量 |
| Variant 系统 | `cva` + `class-variance-authority` | **Swift Enum + ViewModifier 工厂** | 用 enum case 表达 variant，用 ViewModifier 函数表达样式 |
| 类名合并 | `cn()` = `clsx + tailwind-merge` | **`@ViewBuilder` + 条件修饰符** | Swift 无类名冲突问题，简化为样式优先级覆盖 |
| 主题分发 | CSS `:root` / `.dark` | **`EnvironmentKey` + `Theme` struct** | 通过 SwiftUI Environment 注入主题 |
| 色彩空间 | oklch | **Color(oklch:) (iOS 18+)** 或预转换 sRGB | iOS 18 原生支持 oklch；低版本回退 sRGB |
| 组件分发 | CLI 复制 `.tsx` 源码 | **Swift Package + 源码模板** | 提供 `.swift` 模板文件，用户复制到项目 |

---

## 三、POC 控件选型

从 60+ 个组件中选 **2 个最具代表性**的作为 POC：

### 控件 1：`Button`

**选型理由**：
- 最基础、最高频使用的控件
- 完美展示 **variant 系统**（default/outline/secondary/ghost/destructive/link）
- 展示 **size 系统**（default/xs/sm/lg/icon）
- 展示 **`asChild` 多态**（Swift 中用 `ButtonStyle` + `buttonStyle` 修饰符实现）
- 不依赖任何外部库，纯样式

**源参考**：`apps/v4/registry/bases/radix/ui/button.tsx`

### 控件 2：`Card`

**选型理由**：
- 展示 **复合组件** 的组合模式（Header / Title / Description / Action / Content / Footer）
- 展示 **设计 token 的语义应用**（card / card-foreground / border / radius）
- 展示 **slot 模式**（Swift 中用 `@ViewBuilder` + 容器 View 实现）
- 布局逻辑简单（VStack + Grid），易于验证 SwiftUI 映射

**源参考**：`apps/v4/registry/bases/radix/ui/card.tsx`

---

## 四、架构设计

### 4.1 目录结构（实际）

```
shadcn-swift/
├── Package.swift
├── Sources/
│   └── ShadcnSwiftUI/
│       ├── Theme/
│       │   ├── DesignToken.swift
│       │   ├── Theme.swift
│       │   ├── Themes.swift
│       │   └── ThemeEnvironment.swift
│       ├── Utils/
│       │   └── Color+OKLCH.swift
│       └── Components/
│           ├── Alert/Alert.swift
│           ├── Avatar/Avatar.swift
│           ├── Badge/Badge.swift
│           ├── Button/Button.swift
│           ├── Card/Card.swift
│           ├── Checkbox/Checkbox.swift
│           ├── Input/Input.swift
│           ├── Label/Label.swift
│           ├── Progress/Progress.swift
│           ├── RadioGroup/RadioGroup.swift
│           ├── Separator/Separator.swift
│           ├── Skeleton/Skeleton.swift
│           ├── Switch/Switch.swift
│           ├── Textarea/Textarea.swift
│           └── Toggle/Toggle.swift
├── Tests/
│   └── ShadcnSwiftUITests/
├── docs/
│   ├── design-tokens.md
│   ├── migration-guide.md
│   ├── custom-style.md
│   ├── component-template.swift
│   ├── p0-components-plan.md
│   └── p1-p2-p3-components.md
└── ShadcnSwift/            # Demo App (Xcode)
    └── ShadcnSwift/
        ├── ContentView.swift
        └── ShadcnSwiftApp.swift
```

### 4.2 设计 Token 映射

将 shadcn/ui 的 CSS 变量映射为 Swift 的 `DesignToken` struct：

| shadcn CSS 变量 | Swift Token | 类型 | 说明 |
|---|---|---|---|
| `--background` | `token.background` | `Color` | 页面背景 |
| `--foreground` | `token.foreground` | `Color` | 主文字色 |
| `--card` | `token.card` | `Color` | 卡片背景 |
| `--card-foreground` | `token.cardForeground` | `Color` | 卡片文字色 |
| `--primary` | `token.primary` | `Color` | 主强调色 |
| `--primary-foreground` | `token.primaryForeground` | `Color` | 主强调色上的文字 |
| `--secondary` | `token.secondary` | `Color` | 次要背景 |
| `--muted` | `token.muted` | `Color` | 静默背景 |
| `--muted-foreground` | `token.mutedForeground` | `Color` | 辅助文字 |
| `--accent` | `token.accent` | `Color` | 强调背景 |
| `--destructive` | `token.destructive` | `Color` | 危险/删除色 |
| `--border` | `token.border` | `Color` | 边框色 |
| `--input` | `token.input` | `Color` | 输入框边框 |
| `--ring` | `token.ring` | `Color` | 焦点环 |
| `--radius` | `token.radius` | `CGFloat` | 全局圆角（默认 0.625rem ≈ 10pt） |

### 4.3 主题系统设计

```swift
// 设计 Token（语义化颜色）
struct DesignToken {
    let background: Color
    let foreground: Color
    let primary: Color
    let primaryForeground: Color
    let secondary: Color
    let muted: Color
    let mutedForeground: Color
    let accent: Color
    let accentForeground: Color
    let destructive: Color
    let border: Color
    let input: Color
    let ring: Color
    let radius: CGFloat
    // ... card / popover / sidebar 等
}

// 主题 = base color + light/dark 变体
struct Theme {
    let name: String          // "zinc", "neutral", ...
    let light: DesignToken
    let dark: DesignToken
}

// 通过 SwiftUI Environment 注入
struct ThemeEnvironmentKey: EnvironmentKey {
    static let defaultValue: DesignToken = Themes.zinc.light
}

extension EnvironmentValues {
    var shadcnToken: DesignToken {
        get { self[ThemeEnvironmentKey.self] }
        set { self[ThemeEnvironmentKey.self] = newValue }
    }
}

// 组件内使用：
// @Environment(\.shadcnToken) private var token
```

### 4.4 Variant 模式映射

shadcn/ui 用 `cva` 定义 variant，Swift 用 **enum + ButtonStyle 内的 switch/case**：

```swift
// Variant 定义
public enum ButtonVariant: String, CaseIterable, Sendable {
    case `default`, outline, secondary, ghost, destructive, link
}

// ButtonStyle 内部样式分发（switch/case）
public struct ShadcnButtonStyle: ButtonStyle {
    @Environment(\.shadcnToken) private var token

    private func backgroundColor(isPressed: Bool) -> Color {
        switch variant {
        case .default:     return isPressed ? token.primary.opacity(0.8) : token.primary
        case .outline, .ghost, .link: return .clear
        case .secondary:   return token.secondary
        case .destructive: return token.destructive
        }
    }
}

// 使用
Button("Click") { }
    .shadcnButton(variant: .outline, size: .sm)
```

### 4.5 自定义样式 API

两种方式共存，互补：

1. **First-class 参数** — init 参数直接替换内部默认值
   ```swift
   Card(cornerRadius: 24, borderWidth: 2, borderColor: .blue) { ... }
   Button("Pill") { }.shadcnButton(cornerRadius: 999)
   ```
2. **customStyle 闭包** — 在最外层追加 modifier
   ```swift
   .shadcnButton(variant: .default) { label in
       AnyView(label.shadow(color: .blue.opacity(0.5), radius: 8))
   }
   ```

---

## 五、实施步骤

### Step 1：项目脚手架（0.5 天）✅

- [x] 初始化 `shadcn-swift/` 目录与 `Package.swift`
- [x] 配置 Swift Package（iOS 18+ / macOS 15+ deployment target）
- [x] 创建 Demo App 工程（`ShadcnSwift/`）

### Step 2：色彩工具层（0.5 天）✅

- [x] 实现 `Color+OKLCH.swift`：解析 `"oklch(0.205 0 0)"` 字符串为 SwiftUI `Color`
  - iOS 18+ 优先使用原生 `Color(oklch:)`
  - 回退：oklch → linear sRGB → `Color(red:green:blue:)`
- [ ] 单元测试：验证所有 `themes.ts` 中的颜色值能正确解析

### Step 3：设计 Token 与主题系统（1 天）✅

- [x] 定义 `DesignToken` struct（含所有语义 token）
- [x] 实现 `Theme` struct 与 `Themes` 内置主题
- [x] 移植 `themes.ts` 中的 neutral/stone/zinc + rose/orange/green/blue/violet（8 个主题）
- [ ] 补充剩余 base color（mauve/olive/mist/taupe）+ 其余 11 个 accent color
- [x] 实现 `ThemeEnvironmentKey`，支持 `.light` / `.dark` 自动切换（`@Environment(\.colorScheme)`）
- [ ] Demo：一个纯色块预览页，展示所有 token

### Step 4：Button 控件移植（1 天）✅

- [x] 定义 `ButtonVariant` / `ButtonSize` enum
- [x] 实现 `ShadcnButtonStyle: ButtonStyle`
- [x] 实现 `ShadcnButton` View + `.shadcnButton()` modifier
- [x] 映射 6 种 variant 样式（default/outline/secondary/ghost/destructive/link）
- [x] 映射 8 种 size（含 icon 系列）
- [x] Demo：展示所有 variant × size 组合矩阵

### Step 5：Card 控件移植（1 天）✅

- [x] 实现 `Card` 容器 View（VStack + 背景色 + 圆角 + 边框）
- [x] 实现 `CardHeader` / `CardTitle` / `CardDescription` / `CardAction` / `CardContent` / `CardFooter`
- [x] 支持 `size: default | sm` 变体
- [x] Demo：展示 Card 的各种组合

### Step 6：Demo App 集成与验收（0.5 天）✅

- [x] Demo App 首页：展示全部 15 组件的完整示例
- [x] 支持运行时切换主题（zinc/rose/orange/green/blue/violet）
- [x] 支持运行时切换 light/dark 模式（跟随系统）
- [x] 支持 Button + Card Customizer（实时调参 + preset 分享）

### Step 7：文档与模板（0.5 天）✅

- [x] 编写 `design-tokens.md`（Web → Swift token 对照表）
- [x] 编写 `migration-guide.md`（组件迁移 SOP）
- [x] 提供组件 `.swift` 源码模板（`component-template.swift`）
- [x] 编写 `p0-components-plan.md`（P0 组件详细规格）
- [x] 编写 `p1-p2-p3-components.md`（P1/P2/P3 待移植清单）

---

## 六、验收标准

| # | 验收项 | 通过标准 |
|---|---|---|
| 1 | oklch 颜色解析 | `themes.ts` 中所有颜色值能解析为正确的 SwiftUI Color，误差 < 1% |
| 2 | 主题切换 | 运行时切换 base color（zinc→rose）后，所有控件颜色实时更新 |
| 3 | Dark Mode | 跟随系统 dark mode 自动切换 token 集合 |
| 4 | Button variant | 6 种 variant 视觉与 shadcn/ui 官网一致（含 hover/press 态） |
| 5 | Button size | 8 种 size 尺寸正确，icon-only 按钮为正方形 |
| 6 | Card 组合 | Header/Title/Description/Action/Content/Footer 正确布局，CardAction 在右上角 |
| 7 | 源码可读 | 组件源码风格与 shadcn 保持一致（单文件、函数式、dataSlot 语义保留） |
| 8 | SPM 可集成 | Demo App 通过 Swift Package Manager 引入 `shadcn-swift` 依赖 |

---

## 七、风险与对策

| 风险 | 影响 | 对策 |
|---|---|---|
| iOS 17 不原生支持 oklch | 颜色显示偏差 | 实现 oklch→sRGB 转换函数；推荐 iOS 18+ 原生路径 |
| SwiftUI 的 `ButtonStyle` 无法完全模拟 `asChild` | 多态受限 | 用 `@ViewBuilder` label + `ButtonStyle` 组合，或提供 `ShadcnButton` View 封装 |
| Tailwind 的间距/字号体系在 Swift 无对应 | 布局精度 | 建立 Spacing/Typography 常量表，映射 Tailwind 的 spacing scale（0.25rem = 4pt 基准） |
| `cn()` 的 tailwind-merge 语义 | 类冲突解决 | Swift 无字符串类名，改用 ViewModifier 优先级覆盖，天然解决冲突 |
| 动画曲线差异 | 过渡观感 | shadcn 默认 `transition-all 150ms`，SwiftUI 用 `.animation(.easeInOut(duration: 0.15))` 对齐 |

---

## 八、后续路线

### 已完成 ✅
1. **P0 表单类**：Badge / Input / Switch / Separator / Avatar
2. **P1 反馈类**：Alert / Textarea / Label / Checkbox / RadioGroup / Progress / Skeleton / Toggle

### 待移植 🔲
3. **P1 剩余**：Slider / Collapsible / NativeSelect / Direction / Kbd
4. **P2 浮层类**：Dialog / Sheet / AlertDialog / Popover / Tooltip / HoverCard
5. **P2 导航类**：Tabs / Breadcrumb / Pagination / NavigationMenu
6. **P3 复杂控件**：DropdownMenu / Select / Combobox / Command / Calendar / Chart / Table / DataTable / Carousel / Sidebar / Drawer 等
7. **P3 新增组件**：Bubble / Message / MessageScroller / Attachment / Marker / Toast / Spinner 等
8. **CLI 工具**：实现 `shadcn-swift add <component>` 命令行
9. **Figma 同步**：设计 token 导出为 Figma Variables

---

## 九、参考源码索引

| 内容 | 路径 |
|---|---|
| Button 源码 | `shadcnui/apps/v4/registry/bases/radix/ui/button.tsx` |
| Card 源码 | `shadcnui/apps/v4/registry/bases/radix/ui/card.tsx` |
| Badge 源码（variant 参考） | `shadcnui/apps/v4/registry/bases/radix/ui/badge.tsx` |
| Tabs 源码（cva + 复杂样式 参考） | `shadcnui/apps/v4/registry/bases/radix/ui/tabs.tsx` |
| 主题定义 | `shadcnui/apps/v4/registry/themes.ts` |
| Base color 列表 | `shadcnui/apps/v4/registry/base-colors.ts` |
| `cn()` 工具 | `shadcnui/apps/v4/registry/bases/radix/lib/utils.ts` |
| 全局 CSS | `shadcnui/apps/v4/app/globals.css` |
