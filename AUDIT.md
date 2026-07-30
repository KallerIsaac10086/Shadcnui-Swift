# shadcn/ui → Swift 组件审计报告

> 生成时间：2026-07-30  
> TSX 基准：`shadcnui/apps/v4/registry/new-york-v4/ui/`  
> Swift 基准：`shadcn-swift/Sources/ShadcnSwiftUI/Components/`

---

## 1. 总览

| | 数量 |
|---|---|
| TSX 组件总数 | 62 |
| Swift 已实现 | 59 |
| Swift 未实现 | 3 |
| Swift 独有 | 2（DatePicker, Typography） |

---

## 2. 完全缺失（TSX 有，Swift 无）

| # | TSX 组件 | 说明 |
|---|---|---|
| 1 | `chart.tsx` | 图表，依赖 Recharts。可实现为 Swift Charts 版本 |
| 2 | `form.tsx` | 表单，依赖 react-hook-form。SwiftUI 有原生 Form |
| 3 | `sidebar.tsx` | 侧边栏导航，依赖 Radix。需完整重写 |

---

## 3. 已实现但有缺陷

### P0 — Select

**TSX demo**：`SelectTrigger` + `SelectValue(placeholder)` + `SelectContent` → `SelectGroup` + `SelectLabel` + `SelectItem`

**Swift 问题**：
- ❌ 没有 `SelectValue` 子组件，placeholder 放在 `Select` 本身上
- ❌ dropdown 用 `ZStack` 内联渲染到组件内部，会被父容器（GlassSection）裁切——跟 Combobox/Menubar 修前的 bug 一样
- ❌ 没有接 Portal 渲染，层级不可控
- ⚠️ `SelectSeparator` 存在但 `SelectLabel` / `SelectGroup` 是否完整待确认

**修复方向**：参照 Combobox 的 Portal 方案，`SelectTrigger` 设 `PortalAnchorKey`，`SelectContent` 往 `PortalHost.shared` 注册 panel

---

### P1 — Popover

**TSX demo**：`Popover` → `PopoverTrigger(asChild)` → `PopoverContent`（Radix 动态定位 4 方向）

**Swift 问题**：
- ❌ 硬编码 `.overlay(alignment: .bottom)`，只支持下方弹出。TSX 由 Radix 自动计算方向并避让屏幕边界
- ❌ 内联 overlay 裁切 bug 同上
- ❌ 没有 `PopoverTrigger` 组件，用 `.popover(isPresented:)` modifier 替代
- ⚠️ 缺 `side` / `align` / `sideOffset` 定位参数

**修复方向**：接 Portal + 支持 position 参数

---

### P2 — DropdownMenu / ContextMenu

**TSX**：`DropdownMenu` → `DropdownMenuTrigger` + `DropdownMenuContent` → `DropdownMenuItem`（Radix，shadcn 主题）

**Swift 问题**：
- ❌ 内部用 SwiftUI 原生 `Menu` 组件，渲染的是系统菜单（白底、系统字体、系统分隔线），完全不是 shadcn 风格
- ❌ `DropdownMenuItem` 只有 Text + action，没有 `variant: .destructive`、`inset`、disabled 等属性
- ⚠️ `ContextMenu` 同样用原生 `contextMenu` modifier

**修复方向**：跟 Menubar 一样改成自定义浮层 + token 渲染

---

### P3 — NavigationMenu

**TSX demo**：`NavigationMenu` → `NavigationMenuList` → `NavigationMenuItem` → `NavigationMenuTrigger` + `NavigationMenuContent`（含下拉面板、link、图标、列表）

**Swift 问题**：
- ❌ 极简实现——`NavigationMenu` 只是 `content()` 的 pass-through，`NavigationMenuList` 只是 `HStack`
- ❌ 完全没有 `NavigationMenuTrigger`、`NavigationMenuContent`、`NavigationMenuLink` 等核心子组件
- ❌ 不能渲染带图标的超链接下拉面板
- ❌ 没有 viewport 行为（移动端适配）

**修复方向**：参照 Menubar 架构，`NavigationMenuTrigger` + `NavigationMenuContent` 分离，portal 渲染

---

### P4 — Command

**TSX demo**：`Command` → `CommandInput` → `CommandList` → `CommandGroup(heading:)` → `CommandItem`（disabled）+ `CommandShortcut` + `CommandSeparator`

**Swift 问题**：
- ❌ `CommandGroup` 没有 `heading` 参数（分组标题）
- ❌ 没有 `CommandShortcut` 子组件
- ❌ 没有 `CommandSeparator` 子组件
- ❌ `CommandItem` 缺 `disabled` 状态、图标 slot
- ⚠️ Swift 版用 `CommandDialog` 包裹，API 与 TSX 不完全对应

---

### P5 — DatePicker（非 shadcn 标准组件）

**状态**：✅ 已通过 `CalendarView` + Popover 改好。Swift 独有的组件。

---

### P6 — 内联浮层裁切问题（全局）

以下组件仍有"浮层被容器裁切/层级被遮挡"的老问题，需要从 ZStack 内联渲染改为 Portal：

| 组件 | 状态 |
|---|---|
| `Combobox` | ✅ 已修 |
| `Menubar` | ✅ 已修 |
| `Select` | ❌ 待修 |
| `Popover` | ❌ 待修 |
| `DropdownMenu` | ❌ 待修 |
| `ContextMenu` | ❌ 待修 |
| `Tooltip` | ❌ 待修 |
| `HoverCard` | ❌ 待修 |

---

## 4. 基础组件（基本 OK）

以下组件 API 完整度较高，token 使用正确，无需大改：

| 组件 | 备注 |
|---|---|
| Dialog | `DialogContent` + `Header/Title/Description/Footer/Close` |
| Drawer | 4 方向 + 拖拽关闭 + `DrawerContent/Header/Title/Footer` |
| Sheet | 结构与 Drawer 相同，`SheetOverlayModifier` |
| Accordion | single/multiple 模式 + chevron 动画 |
| Tabs | `TabsList` + `TabsTrigger` + `TabsContent`，环境传递 |
| Calendar | LazyVGrid 等宽 + 月翻页 + 单日期选择 |
| Table | `Header/Body/Row/Cell/Foot/Caption` 齐全 |
| Slider | 基本功能 |
| Button | 各种 variant |
| Input / Textarea | placeholder / type / invalid |
| Progress / Skeleton | 基本 |
| Badge / Avatar / Label / Kbd | 简单展示 |
| Card / Separator | 基本 |
| Checkbox / Radio / Switch / Toggle | 基本 |
| Breadcrumb / Pagination / Carousel | 基本 |
| Spinner / Empty / AspectRatio | 基本 |
| Alert / AlertDialog | 基本 |
| Collapsible / Resizable / ScrollArea | 基本 |
| Message / Bubble / Attachment | 基本 |
| ButtonGroup / InputGroup / ToggleGroup | 基本 |
| Field / Item / Direction / Marker | 基本 |
| MessageScroller / NativeSelect | 基本 |

---

## 5. 全局基础设施（已完建）

| 模块 | 说明 |
|---|---|
| `PortalHost` + `PortalOverlay` | 全局 Portal 渲染（Radix Portal 等价物） |
| `DesignToken` | 14 套主题令牌 |
| `.shadcnTheme()` | 主题注入 |
| `.shadcnButton()` | Button variant modifier |

---

## 6. 修复优先级建议

| 优先级 | 组件 | 工作量 | 理由 |
|---|---|---|---|
| **P0** | Select | 中 | Dropdown 裁切 bug，用户可见 |
| **P1** | Popover | 中 | 只有 bottom 定位，内联裁切 |
| **P2** | DropdownMenu + ContextMenu | 中 | 原生系统菜单，完全不是 shadcn 风格 |
| **P3** | Command | 小 | 缺子组件，补充即可 |
| **P4** | Tooltip + HoverCard | 中 | 定位参数 + Portal |
| **P5** | NavigationMenu | 大 | 需完整重写子组件体系 |

---

## 7. 不算问题但可优化

- `Typography` 是 Swift 独有组件，TSX 用 Tailwind utility class 实现文本样式
- `Label` 组件在 TSX 中是一个 form label，Swift 中似乎用作 badge label
- 所有组件都使用 `token.radius` 统一定义圆角，符合 design system
- `.shadcnButton(variant:size:)` 是 Button modifier，TSX 中是 `variant` prop
