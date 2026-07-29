# P1 / P2 / P3 组件清单

> 基于 shadcn/ui 源码 (`apps/v4/registry/bases/radix/ui/`) 完整遍历。  
> 已排除 P0 组件: Badge, Input, Switch, Separator, Avatar（详见 `p0-components-plan.md`）。

---

## 🟠 P1 — 表单与反馈（7~12 个组件，中低复杂度）

### Alert（提示横幅）
- **73 行**，4 子组件：Alert / AlertTitle / AlertDescription / AlertAction
- **2 variants**: default (primary 背景), destructive (red 背景)
- **无 Radix 依赖**，纯 div + cva
- Action 区域可嵌入 Button，链接自动 underline
- 移植关键：VStack 容器 + HStack Action 区

### Textarea（多行输入）
- **18 行**，1 组件
- 简单 `<textarea>` wrapper，样式与 Input 一致
- 移植关键：`TextEditor` 或 `TextField(axis: .vertical)`

### Label（表单标签）
- **24 行**，1 组件
- Radix Label primitive 的 thin wrapper
- `peer-disabled:cursor-not-allowed peer-disabled:opacity-50`
- 移植关键：简单 `Text` + 关联 field accessibility

### Checkbox（复选框）
- **38 行**，1 组件
- Radix Checkbox wrapper，带 check icon 指示器
- 移植关键：`ToggleStyle` 或 `Button` + `@State isChecked`

### RadioGroup（单选组）
- **44 行**，2 子组件：RadioGroup / RadioGroupItem
- Circle indicator (inner 8px dot)
- 移植关键：`PickerStyle.radioGroup` 或自定义 layout

### Progress（进度条）
- **31 行**，1 组件
- Track + indicator，CSS `translateX(-X%)` 动画
- 移植关键：`ProgressView` 或自定义 ZStack + `.frame(width:)` 动画

### Skeleton（骨架屏）
- **13 行**，1 组件
- 最简组件：`animate-pulse rounded-md bg-muted`
- 移植关键：`.opacity(0~1 循环)` 或 `.phaseAnimator`

### Toggle（切换按钮）
- **46 行**，1 组件 + `toggleVariants`（可复用）
- **2 variants**: default, outline
- **3 sizes**: default, sm, lg
- `aria-pressed` 状态切换
- 移植关键：类似 Button 但用 `isPressed` 状态切换样式

### Slider（滑动条）
- **59 行**，1 组件
- Track + Range + Thumb，支持多 thumb
- 移植关键：`Slider` 原生控件，自定义 track/accent 颜色

### Collapsible（折叠面板）
- **33 行**，3 子组件：Collapsible / Trigger / Content
- 纯 Radix thin wrapper
- 移植关键：`DisclosureGroup` 原生控件

### NativeSelect（原生下拉）
- **70 行**，3 子组件：NativeSelect / Option / OptGroup
- 带下拉箭头 icon，`appearance-none`
- 移植关键：`Picker` 或自定义 Menu button

### Direction（方向控制）
- **22 行**，2 子组件：DirectionProvider / useDirection
- RTL/LTR 方向切换
- 移植关键：`@Environment(\.layoutDirection)`

### Kbd（键盘快捷键指示器）
- **26 行**，2 子组件：Kbd / KbdGroup
- 小钥匙图标样式，`shadow-[0_1px_1px_rgba(0,0,0,0.2)]`
- 移植关键：简单 VStack + system font mono

---

## 🟡 P2 — 浮层与导航（8 个组件，中高复杂度）

### Tooltip（提示气泡）
- **57 行**，4 子组件：TooltipProvider / Tooltip / Trigger / Content
- Hover 触发浮层，带箭头
- **2 sizes**: default (4px pad), sm (3px pad)
- 移植关键：`.popover` / `.onHover` (macOS) / `.onLongPressGesture` (iOS)

### Popover（弹出卡片）
- **89 行**，4 子组件：Popover / Trigger / Content / Anchor
- 更大更丰富的浮层卡片
- 移植关键：`.popover` / `.sheet` 原生 API

### HoverCard（悬停卡片）
- **44 行**，3 子组件
- Hover 延迟后弹出详细内容
- 移植关键：`.onHover` + dispatchAfter delay

### Dialog（模态对话框）
- **174 行**，7 子组件：Root / Trigger / Portal / Overlay / Content / Header / Footer / Title / Description
- 背景遮罩 + ESC 关闭 + focus trap
- 移植关键：`.sheet` / `.fullScreenCover` / `ZStack` + state

### Sheet（侧滑面板）
- **152 行**，6 子组件
- **4 sides**: top / right / bottom / left
- 半屏/全屏切换
- 移植关键：`.sheet` 原生 + `.presentationDetents`

### AlertDialog（确认对话框）
- **185 行**，12 子组件（最多）
- Dialog + 专用 Action/Cancel 按钮 + Media 区
- **2 sizes**: default, sm
- 移植关键：ZStack overlay + 按钮嵌入

### Tabs（标签页）
- **110 行**，3 子组件：Tabs / List / Trigger / Content
- actived tab underline 动画
- 移植关键：`TabView` 原生 + 自定义 tab bar

### Breadcrumb（面包屑）
- **160+ 行**，7 子组件
- 路径导航，自动插入分隔符
- 移植关键：`HStack` + `ForEach` + separator

---

## 🟢 P3 — 复杂控件与数据展示（8~10 组件，高复杂度）

### DropdownMenu（下拉菜单）
- **272 行**，13 子组件（最庞大）
- 子菜单嵌套支持、Radio 组支持、Checkbox 项支持、分隔线、快捷键显示
- 移植关键：`Menu` 原生 API 或自定义 overlay 菜单

### ContextMenu（右键菜单）
- **27+ 行**，类似 DropdownMenu 的子集
- 移植关键：`.contextMenu` 原生 API

### Select（下拉选择）
- **250+ 行**，复杂 Radix Select wrapper
- 搜索/过滤、分组、placeholder、scroll
- 移植关键：`Picker` 或自定义 menu popup

### Combobox（搜索+选择）
- 搜索输入 + 下拉结果列表
- 键盘导航 (arrow keys)
- 移植关键：`TextField` + `List` overlay

### Command（命令面板）
- ⌘K 风格命令面板，搜索 + 导航 + 分类
- 移植关键：`.searchable` + sheet overlay

### Calendar（日历）
- 日期选择器
- 移植关键：`DatePicker` 原生 + `.graphical` style

### Chart（图表）
- 依赖 Recharts，需对齐 Swift Charts
- 移植关键：`Chart` (iOS 16+) + 数据绑定

### Table（数据表格）
- 表头/行/列/footer，sticky header
- 移植关键：`Table` (iOS 16+) 或 `LazyVGrid` / `List`

### Carousel（轮播）
- 自动播放，paginator dots
- 移植关键：`TabView(style: .page)` + `Timer`

### Tree（树形控件）
- 嵌套展开/折叠
- 移植关键：`List` + `DisclosureGroup` 递归

### Pagination（分页）
- 页码导航
- 移植关键：HStack + Button 组

### Empty State（空状态）
- 图标 + 标题 + 描述 placeholder
- 移植关键：VStack + Image + Text 组合

---

## 选型矩阵

| 维度 | P1 | P2 | P3 |
|---|---|---|---|
| 组件数 | 13 | 8 | 12 |
| 平均行数 | ~40 | ~120 | ~250 |
| Radix 依赖 | 部分有 | 全部有 | 全部有 |
| 移植工时 | 0.5~2h/个 | 2~6h/个 | 4~12h/个 |
| 最佳切入时机 | 做完 P0 后 | P1 完成 80% 后 | P2 完成 50% 后 |
| 推荐第一批 | Alert / Textarea / Checkbox / Skeleton / Toggle | Tooltip / Dialog / Tabs | Menu / Select / Calendar |

## 总计

shadcn/ui 共 **56 个组件**。已完成 2 个（Button, Card）+ P0 计划 5 个 = 进度 7/56。
