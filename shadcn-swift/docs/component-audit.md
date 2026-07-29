# shadcn-swift 组件对照审计报告

> 生成日期：2026-07-29  
> 对比基准：shadcn/ui v4 官方文档（63 个组件）  
> 当前 shadcn-swift 版本：Phase 1+ (P0/P1 完成)

---

## 一、总览

| 维度 | 数量 | 进度 |
|---|---|---|
| shadcn/ui 组件总数 | **63** | — |
| 已移植 | **15** | 23.8% |
| 未移植 | **48** | 76.2% |
| 内置主题 | **8** | 计划 23+ (7 base + 16+ accent) |
| DesignToken | **19 个** | 缺少 ~13 个 (sidebar / chart / destructiveForeground) |

---

## 二、逐组件对照表

### ✅ 已移植（15 个）

| # | shadcn/ui 组件 | Swift 组件 | Variant/Size | 子组件 | 缺失功能 |
|---|---|---|---|---|---|
| 1 | **Button** | `ShadcnButton` + `shadcnButton()` | 6 variants, 8 sizes | — | `ButtonGroup` 未实现 |
| 2 | **Card** | `Card` | 2 sizes | 7 个 (Header/Title/Description/Action/Content/Footer) | — |
| 3 | **Badge** | `Badge` | 6 variants | — | link variant hover underline 未实现 |
| 4 | **Input** | `Input` | — | — | `type` 支持 (password/email/number)、`InputGroup`、`InputOTP`、file input |
| 5 | **Textarea** | `Textarea` | — | — | — |
| 6 | **Label** | `ShadcnLabel` | — | — | peer 自动关联 accessibility |
| 7 | **Switch** | `ShadcnSwitchStyle` (ToggleStyle) | 2 sizes | — | `invalid` 状态、focus ring |
| 8 | **Checkbox** | `Checkbox` | — | — | `indeterminate` 状态 |
| 9 | **RadioGroup** | `RadioGroup` + `RadioItem` | — | 2 个 | — |
| 10 | **Progress** | `Progress` | determinate / indeterminate | — | color variant、indeterminate 文本 |
| 11 | **Skeleton** | `Skeleton` | — | — | — |
| 12 | **Separator** | `Separator` | horizontal / vertical | — | — |
| 13 | **Alert** | `Alert` | default / destructive | 4 个 (Title/Description/Action) | 与 `AlertDialog` 不同组件 |
| 14 | **Avatar** | `Avatar` | 3 sizes | 6 个 (Image/Fallback/Badge/Group/GroupCount) | — |
| 15 | **Toggle** | `ShadcnToggle` | 2 variants, 3 sizes | — | `ToggleGroup` 未实现 |

### ❌ 未移植（48 个）

#### 🟢 P1 级别 — 表单与反馈（低~中复杂度，已规划）

| # | 组件 | 源码行数 | 子组件数 | 复杂度 | Swift 映射建议 |
|---|---|---|---|---|---|
| 1 | **Slider** | 59 | 1 | ⭐⭐ | `Slider` 原生控件 + 自定义 track/accent |
| 2 | **Collapsible** | 33 | 3 | ⭐ | `DisclosureGroup` 原生 |
| 3 | **Native Select** | 70 | 3 | ⭐⭐ | `Picker` 或自定义 Menu |
| 4 | **Direction** | 22 | 2 | ⭐ | `@Environment(\.layoutDirection)` |
| 5 | **Kbd** | 26 | 2 | ⭐ | 简单 `HStack` + mono font |

#### 🟡 P2 级别 — 浮层与导航（中高复杂度）

| # | 组件 | 源码行数 | 子组件数 | 复杂度 | Swift 映射建议 |
|---|---|---|---|---|---|
| 6 | **Dialog** | 174 | 9 (Root/Trigger/Portal/Overlay/Content/Header/Footer/Title/Description) | ⭐⭐⭐⭐ | `.sheet` / `ZStack` + `@State` |
| 7 | **Sheet** | 152 | 6 | ⭐⭐⭐⭐ | `.sheet` + `.presentationDetents` |
| 8 | **AlertDialog** | 185 | 12 (最多子组件) | ⭐⭐⭐⭐ | ZStack overlay + Action/Cancel |
| 9 | **Tooltip** | 57 | 4 (Provider/Trigger/Content) | ⭐⭐⭐ | `.popover` / `.onHover` (macOS) |
| 10 | **Popover** | 89 | 4 | ⭐⭐⭐ | `.popover` / `.sheet` |
| 11 | **HoverCard** | 44 | 3 | ⭐⭐⭐ | `.onHover` + dispatch delay |
| 12 | **Tabs** | 110 | 3 (List/Trigger/Content) | ⭐⭐⭐ | `TabView` + 自定义 tab bar |
| 13 | **Breadcrumb** | 160+ | 7 | ⭐⭐⭐ | `HStack` + `ForEach` + separator |

#### 🔴 P3 级别 — 复杂控件与数据展示（高复杂度）

| # | 组件 | 源码行数 | 子组件数 | 复杂度 | Swift 映射建议 |
|---|---|---|---|---|---|
| 14 | **DropdownMenu** | 272 | 13 | ⭐⭐⭐⭐⭐ | `Menu` 原生 API 或自定义 overlay |
| 15 | **ContextMenu** | 27+ | ~6 | ⭐⭐⭐ | `.contextMenu` 原生 API |
| 16 | **Select** | 250+ | ~8 | ⭐⭐⭐⭐⭐ | `Picker` 或自定义 popup |
| 17 | **Combobox** | ~200 | ~5 | ⭐⭐⭐⭐ | `TextField` + `List` overlay |
| 18 | **Command** | ~150 | ~6 | ⭐⭐⭐⭐ | `.searchable` + sheet overlay |
| 19 | **Calendar** | ~200 | ~8 | ⭐⭐⭐⭐ | `DatePicker` + `.graphical` style |
| 20 | **Chart** | ~300 | ~10 | ⭐⭐⭐⭐⭐ | `Chart` (iOS 16+) + 数据绑定 |
| 21 | **Table** | ~150 | ~5 | ⭐⭐⭐⭐ | `Table` (iOS 16+) 或 `LazyVGrid` |
| 22 | **Data Table** | ~500 | ~12 | ⭐⭐⭐⭐⭐ | 自定义 `List`/`Grid` + 排序/过滤 |
| 23 | **Carousel** | ~80 | ~3 | ⭐⭐⭐ | `TabView(style: .page)` + `Timer` |
| 24 | **Pagination** | ~50 | ~4 | ⭐⭐ | `HStack` + Button 组 |
| 25 | **Accordion** | ~100 | 5 | ⭐⭐⭐ | `DisclosureGroup` 或自定义 |

#### 🆕 新组件 & 其他

| # | 组件 | 源码行数 | 复杂度 | Swift 映射建议 |
|---|---|---|---|---|
| 26 | **Drawer** | ~180 | ⭐⭐⭐⭐ | `.sheet` + 方向动画 |
| 27 | **Navigation Menu** | ~200 | ⭐⭐⭐⭐ | 自定义 `HStack` + 子菜单 |
| 28 | **Menubar** | ~120 | ⭐⭐⭐ | `MenuBarExtra` (macOS) |
| 29 | **Scroll Area** | ~60 | ⭐⭐ | `ScrollView` + 自定义 scrollbar |
| 30 | **Resizable** | ~80 | ⭐⭐⭐⭐ | `GeometryReader` + drag gesture |
| 31 | **Sidebar** | ~350 | ⭐⭐⭐⭐⭐ | `NavigationSplitView` + 自定义 |
| 32 | **Spinner** | ~20 | ⭐ | `ProgressView()` 或自定义 |
| 33 | **Empty (State)** | ~30 | ⭐ | `VStack` + Image/Text 组合 |
| 34 | **Field** | ~50 | ⭐⭐ | VStack: Label + Input + error msg |
| 35 | **Input Group** | ~60 | ⭐⭐ | HStack wrapper for Inputs |
| 36 | **Input OTP** | ~80 | ⭐⭐⭐ | 6-digit segmented field |
| 37 | **Item** | ~40 | ⭐ | `HStack` selectable row |
| 38 | **Toggle Group** | ~60 | ⭐⭐ | HStack + `ShadcnToggle` items |
| 39 | **Button Group** | ~50 | ⭐⭐ | HStack with merged borders |
| 40 | **Typography** | ~150 | ⭐⭐ | 预设 Text styles (h1~h4/p/blockquote/code) |
| 41 | **Aspect Ratio** | ~30 | ⭐ | `.aspectRatio(contentMode:)` |
| 42 | **Bubble** 🆕 | ~40 | ⭐⭐ | Chat bubble with tail |
| 43 | **Message** 🆕 | ~50 | ⭐⭐ | Message row with avatar |
| 44 | **Message Scroller** 🆕 | ~80 | ⭐⭐⭐ | Auto-scroll chat list |
| 45 | **Marker** 🆕 | ~30 | ⭐ | Inline mark/highlight |
| 46 | **Toast** 🆕 | ~100 | ⭐⭐⭐ | `.overlay` + timer + position |
| 47 | **Attachment** 🆕 | ~50 | ⭐⭐ | File attachment pill |
| 48 | **Date Picker** | ~100 | ⭐⭐⭐ | `DatePicker` + `.compact` style |

---

## 三、DesignToken 缺口对照

### 当前已实现（19 个）

```
background, foreground
card, cardForeground
popover, popoverForeground
primary, primaryForeground
secondary, secondaryForeground
muted, mutedForeground
accent, accentForeground
destructive
border, input, ring
radius
```

### 缺失的 shadcn/ui CSS 变量

| CSS 变量 | Swift 建议名称 | 用途 | 影响组件 |
|---|---|---|---|
| `--destructive-foreground` | `destructiveForeground` | 危险按钮文字色 | Button (destructive variant) |
| `--sidebar` | `sidebar` | 侧边栏背景 | Sidebar |
| `--sidebar-foreground` | `sidebarForeground` | 侧边栏文字 | Sidebar |
| `--sidebar-primary` | `sidebarPrimary` | 侧边栏选中项背景 | Sidebar |
| `--sidebar-primary-foreground` | `sidebarPrimaryForeground` | 侧边栏选中项文字 | Sidebar |
| `--sidebar-accent` | `sidebarAccent` | 侧边栏 hover 背景 | Sidebar |
| `--sidebar-accent-foreground` | `sidebarAccentForeground` | 侧边栏 hover 文字 | Sidebar |
| `--sidebar-border` | `sidebarBorder` | 侧边栏分割线 | Sidebar |
| `--sidebar-ring` | `sidebarRing` | 侧边栏焦点环 | Sidebar |
| `--chart-1` ~ `--chart-5` | `chart1` ~ `chart5` | 图表系列色 | Chart |

> 共缺失 **14 个** token（`destructiveForeground` + 8 sidebar + 5 chart）

---

## 四、主题系统缺口

### 当前 8 个主题 vs shadcn/ui 完整主题

| 类别 | shadcn/ui 完整列表 | 已移植 | 缺失 |
|---|---|---|---|
| **Base Colors** | neutral, zinc, stone, **mauve**, **olive**, **mist**, **taupe** | 3 | 4 |
| **Accent Colors** | rose, orange, green, blue, violet, **yellow**, **red**, **slate**, **gray**, **lime**, **emerald**, **teal**, **cyan**, **sky**, **indigo**, **purple**, **fuchsia**, **pink** | 5 | 13 |

> 缺失 4 个 base + 13 个 accent = **17 个主题**

---

## 五、已移植组件功能缺口详解

### 5.1 Button
- ❌ **ButtonGroup**: 多个 Button 紧邻排列时共享边框（合并中间边框线）
- 源文件：shadcn/ui `button-group.tsx`

### 5.2 Input
- ❌ **类型支持**: password（SecureField）、email/newline/password keyboard type、number（decimalPad）
- ❌ **InputGroup**: 多个 Input 组（如 URL input + Select 前缀）
- ❌ **InputOTP**: 6 位一次性验证码输入框
- ❌ **File Input**: 虽然 SwiftUI 不常用，但 shadcn 原生支持 `<input type="file">`

### 5.3 Checkbox
- ❌ **Indeterminate 状态**: 半选态（部分子项选中时，父 checkbox 显示横线而非勾）
- 源实现：Radix Checkbox `data-state="indeterminate"`

### 5.4 Switch
- ❌ **Invalid 状态**: `aria-invalid` 时边框变红色
- ❌ **Focus ring**: focus-visible 时的 ring overlay
- ❌ **Hover 遮罩**: macOS 上的 hover 效果

### 5.5 Toggle
- ❌ **ToggleGroup**: 多个 Toggle 按钮互斥/多选排列
- 源实现：Radix ToggleGroup primitive

### 5.6 Badge
- ❌ link variant 的 hover `underline` 效果
- ❌ ghost variant 的 hover `bg-muted` 效果

### 5.7 Alert
- ⚠️ shadcn/ui 中 **Alert** 和 **AlertDialog** 是两个独立组件：
  - **Alert**: 内联提示横幅（本组件 OK）
  - **AlertDialog**: 模态确认对话框（完全未移植，185 行/12 子组件）

### 5.8 Progress
- ❌ 缺少 color variant（shadcn 支持任意颜色自定义）
- ❌ 缺少 indeterminate 的文本标签（如 "Loading..."）

---

## 六、基础设施缺口

| 项目 | 状态 | 说明 |
|---|---|---|
| **CLI 工具** | ❌ | PLAN 第八节规划：`shadcn-swift add <component>` 命令，从 registry 下载源码 |
| **Figma 同步** | ❌ | PLAN 第八节规划：design token 导出为 Figma Variables |
| **单元测试** | ❌ | `Package.swift` 定义了 `testTarget`，但 `Tests/` 目录基本为空 |
| **Accessibility** | ❌ | 所有组件缺少 `accessibilityLabel` / `accessibilityHint` 等无障碍标注 |
| **RTL 支持** | ❌ | 缺少 `Direction` 组件，未测试 RTL 布局 |
| **ToggleGroup** | ❌ | Button/Toggle 组布局模式 |
| **Demo App Dark Mode 手动切换** | ⚠️ | 仅跟随系统，无手动切换开关 |
| **组件文档** | ⚠️ | 有 migration-guide、custom-style 等，但缺少每个组件的独立文档页 |
| **macOS 适配** | ⚠️ | Package 声明 macOS 15+，但未测试 `.onHover` / MenuBar 等 mac 专属交互 |

---

## 七、源码对照索引

以下为 shadcn/ui 源码中尚未移植的关键文件路径参考：

| 内容 | shadcn/ui 路径 |
|---|---|
| AlertDialog | `apps/v4/registry/bases/radix/ui/alert-dialog.tsx` |
| Dialog | `apps/v4/registry/bases/radix/ui/dialog.tsx` |
| Sheet | `apps/v4/registry/bases/radix/ui/sheet.tsx` |
| Select | `apps/v4/registry/bases/radix/ui/select.tsx` |
| DropdownMenu | `apps/v4/registry/bases/radix/ui/dropdown-menu.tsx` |
| Tabs | `apps/v4/registry/bases/radix/ui/tabs.tsx` |
| Tooltip | `apps/v4/registry/bases/radix/ui/tooltip.tsx` |
| Popover | `apps/v4/registry/bases/radix/ui/popover.tsx` |
| Command | `apps/v4/registry/bases/radix/ui/command.tsx` |
| Combobox | `apps/v4/registry/bases/radix/ui/combobox.tsx` |
| Slider | `apps/v4/registry/bases/radix/ui/slider.tsx` |
| Collapsible | `apps/v4/registry/bases/radix/ui/collapsible.tsx` |
| Accordion | `apps/v4/registry/bases/radix/ui/accordion.tsx` |
| Breadcrumb | `apps/v4/registry/bases/radix/ui/breadcrumb.tsx` |
| Calendar | `apps/v4/registry/bases/radix/ui/calendar.tsx` |
| Table | `apps/v4/registry/bases/radix/ui/table.tsx` |
| Button Group | `apps/v4/registry/bases/radix/ui/button-group.tsx` |
| Toggle Group | `apps/v4/registry/bases/radix/ui/toggle-group.tsx` |
| Input Group | `apps/v4/registry/bases/radix/ui/input-group.tsx` |
| Input OTP | `apps/v4/registry/bases/radix/ui/input-otp.tsx` |
| 主题定义 | `apps/v4/registry/themes.ts` |
| Base colors | `apps/v4/registry/base-colors.ts` |
| 全局 CSS | `apps/v4/app/globals.css` |

---

## 八、推荐移植优先级

### Phase 2（下一个迭代，预计 7~10 天）

以 **补全 P1 表单体系** + **核心 P2 浮层组件** 为目标：

```
Week 1:
  Day 1:    Slider + Collapsible
  Day 2:    Native Select + Direction
  Day 3:    ButtonGroup + ToggleGroup + InputGroup → 补齐已有组件
  Day 4:    Kbd + Empty + Field → 小件快速扫尾
  Day 5:    Tooltip + HoverCard → 简单浮层

Week 2:
  Day 6:    Dialog → 最重要的 P2 组件
  Day 7:    Sheet + AlertDialog → Dialog 的变体
  Day 8:    Popover → 弹窗卡片
  Day 9:    Tabs → 导航基础
  Day 10:   Breadcrumb → 导航基础
```

### Phase 3（后续）

```
P3: DropdownMenu → Select → Combobox → Command → Calendar → Chart → Table → DataTable
新组件: Accordion → Carousel → Drawer → Sidebar → Pagination → Spinner → Typography
Token 补全: sidebar tokens + chart colors + 新主题
工具链: CLI + Figma + Unit Tests + Accessibility
```

---

## 九、统计摘要

```
shadcn/ui 总计:  63 组件
已移植:          15 组件 (23.8%)
未移植:          48 组件 (76.2%)

其中:
  P1 简单表单/反馈:  5 未移植
  P2 浮层/导航:      8 未移植
  P3 复杂控件/数据:  12 未移植
  新增组件:          7 未移植 (Attachment/Bubble/Marker/Message/MessageScroller/Toast)
  其他:             16 未移植 (ButtonGroup/ToggleGroup/InputGroup/OTP/Spinner/Empty/Field/Kbd/Direction/native select/Collapsible/AspectRatio/Typography/ScrollArea/Resizable/DatePicker)

DesignToken:      19/33 已实现 (57.6%)
内置主题:         8/25 已实现 (32%)
```

---

> **下一步**: 建议优先完成 Phase 2 中列出的 Slider → Dialog 链路，这能覆盖约 70% 的日常表单场景。之后集中处理 P3 的 Select/Combobox/Command 三件套（它们底层共享 Radix Popover primitive，可以一起做）。
