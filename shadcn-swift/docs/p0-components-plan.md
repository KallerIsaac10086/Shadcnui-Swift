# P0 组件移植计划

> 基于 shadcn/ui 源码 (`apps/v4/registry/bases/radix/ui/`) + 样式表 (`style-nova.css`) 完整调研。

---

## 1. Badge（标签徽章）

**源文件**: `badge.tsx` (45 行)  
**CSS**: 6 个 variant 类 + 1 个 base 类  
**复杂度**: ⭐ 极低

### 6 种 Variant

| Variant | CSS 映射 | SwiftUI 颜色 |
|---|---|---|
| `default` | `bg-primary text-primary-foreground` | `.background(token.primary)`, `.foregroundColor(token.primaryForeground)` |
| `secondary` | `bg-secondary text-secondary-foreground` | `.background(token.secondary)`, `.foregroundColor(token.secondaryForeground)` |
| `destructive` | `bg-destructive/10 text-destructive` | `.background(token.destructive.opacity(0.1))`, `.foregroundColor(token.destructive)` |
| `outline` | `border-border text-foreground` | `.background(.clear)`, overlay border `token.border` |
| `ghost` | (透明，hover 时 bg-muted) | `.background(.clear)` |
| `link` | `text-primary underline-offset-4 hover:underline` | `.foregroundColor(token.primary)`, `.underline()` |

### 尺寸与圆角

- 高度: `h-5` ≈ 20pt
- 水平 padding: `px-2` ≈ 8pt × 2
- 垂直 padding: `py-0.5` ≈ 2pt
- 字体: `text-xs font-medium` ≈ 12pt `.medium`
- 圆角: `rounded-4xl` ≈ 完全药丸形 (cornerRadius = height / 2 = 10pt)
- 间距: `gap-1` ≈ 4pt (用于 icon + text)

### 状态

- **focus-visible**: `ring-3 ring-ring/50` → overlay + 颜色
- **disabled**: `opacity-50` (通过父级 opacity 实现)
- **aria-invalid**: `border-destructive ring-destructive/20`
- **hover (link)**: `underline`, `underline-offset-4`
- **hover (ghost)**: `bg-muted text-muted-foreground`

### 结构

```
Badge (View)
├── Text (label)
├── Image? (optional icon, [&>svg]:size-3)
└── Badge 本身是 inline-flex，w-fit，不撑满父容器
```

### 移植关键点

1. `BadgeVariant` enum: `default`, `secondary`, `destructive`, `outline`, `ghost`, `link`
2. `.clipShape(Capsule())` 实现 rounded-full
3. `@ViewBuilder` label 参数支持文本 + 图标组合
4. `focus-visible` → 在 iOS 上通过 `.focusable()` / `accessibilityFocused` 模拟

---

## 2. Input（输入框）

**源文件**: `input.tsx` (19 行)  
**CSS**: 1 个类  
**复杂度**: ⭐ 极低

### 尺寸

| 属性 | CSS | SwiftUI |
|---|---|---|
| 高度 | `h-8` = 32pt | `.frame(height: 32)` |
| 水平 padding | `px-2.5` = 10pt | `.padding(.horizontal, 10)` |
| 垂直 padding | `py-1` = 4pt | `.padding(.vertical, 4)` |
| 圆角 | `rounded-lg` ≈ 8pt | `cornerRadius: token.radius` |
| 字体 | `text-base` (16pt) / `md:text-sm` (14pt) | `.font(.system(size: 14))` |

### 颜色

| 场景 | CSS | SwiftUI |
|---|---|---|
| 背景 | `bg-transparent` (dark:`bg-input/30`) | `.background(.clear)` 或 `token.background.opacity(0.3)` |
| 边框 | `border border-input` | `.overlay(RoundedRectangle.strokeBorder(token.input, 1))` |
| 文字 | 继承 foreground | `.foregroundColor(token.foreground)` |
| placeholder | `text-muted-foreground` | (SwiftUI TextField 原生 placeholder) |
| file button | `file:text-foreground` | N/A (Swift 无 file input，可用 trailing icon 代替) |

### 状态

| 状态 | CSS | SwiftUI |
|---|---|---|
| focus | `border-ring ring-ring/50 ring-3` | `.overlay(RoundedRectangle.strokeBorder(token.ring, 3))` |
| disabled | `opacity-50 cursor-not-allowed` | `.disabled(true)`, `.opacity(0.5)` |
| invalid | `border-destructive ring-destructive/20 ring-3` | 自定义 @State 控制 border 颜色 |

### 结构

```
Input
├── TextField (SwiftUI 原生)
├── 背景: .clear 或 token.input/30
├── 边框: token.input
└── focus ring animation: 150ms ease-in-out
```

### 移植关键点

1. 简单地封装 `TextField`，应用 shadcn 风格的边框、圆角、padding
2. 支持 `@Binding<String>` 双向绑定
3. Focus 状态 → `@FocusState` + 条件 overlay
4. `placeholder` 利用 SwiftUI 原生的 `TextField("placeholder", text:)`

---

## 3. Switch（开关）

**源文件**: `switch.tsx` (33 行)  
**CSS**: 2 个 size variant  
**复杂度**: ⭐⭐ 中等（动画 + 尺寸映射）

### 2 种尺寸

| Size | Track (W×H) | Thumb | translate-x |
|---|---|---|---|
| `default` | 32px × 18.4px | 16px × 16px | checked: translate-x `calc(100%-2px)` |
| `sm` | 24px × 14px | 12px × 12px | checked: translate-x `calc(100%-2px)` |

### 颜色

| 状态 | Track | Thumb |
|---|---|---|
| checked | `bg-primary` | `bg-background` |
| unchecked | `bg-input` | `bg-background` |
| disabled | `opacity-50` | — |
| focus | `ring-ring/50 ring-3` | — |
| invalid | `border-destructive ring-destructive/20` | — |

### 圆角

- Track: `rounded-full` → Capsule shape
- Thumb: `rounded-full` → Circle

### 动画

- `transition-all` → `.animation(.easeInOut(duration: 0.15), value: isOn)`
- Thumb translate → 用 `.offset(x:)` 配合 `@State isOn`

### 结构

```
Switch
├── RoundedRectangle (track)
│   ├── 宽度: 32 (default) / 24 (sm)
│   ├── 高度: 18.4 (default) / 14 (sm)
│   ├── 颜色: .primary (on) / .input (off)
│   └── 圆角: Capsule
│
└── Circle (thumb)
    ├── 直径: 16 (default) / 12 (sm)
    ├── 颜色: .background
    └── offset(x:) 动画切换
```

### 移植关键点

1. `ToggleStyle` 自定义实现 → `ShadcnSwitchStyle: ToggleStyle`
2. Thumb 位移用 `offset(x:)` + `.animation()`
3. 点击区域扩到 `-inset-x-3 -inset-y-2` → SwiftUI 默认可交互区域
4. 需要 macOS `onHover` 支持 hover 遮罩（可选）

---

## 4. Separator（分割线）

**源文件**: `separator.tsx` (28 行)  
**CSS**: 无额外类  
**复杂度**: ⭐ 最低

### 方向

| Orientation | CSS | SwiftUI |
|---|---|---|
| horizontal | `h-px w-full` | `Divider()` 或 `.frame(height: 1).frame(maxWidth: .infinity)` |
| vertical | `w-px self-stretch` | `Divider().frame(width: 1)` 或 `Rectangle().frame(width: 1)` |

### 属性

- 颜色: `bg-border` → `token.border`
- `decorative` — 标记是否纯装饰（无语义含义）

### 结构

```
Separator
├── 水平: 1pt 高 × full width 线条
├── 垂直: 1pt 宽 × full height 线条
└── 颜色: token.border
```

### 移植关键点

1. 极其简单 — SwiftUI 已有 `Divider()` 但颜色不可控
2. 用 `Rectangle()` 或 `.frame()` + `token.border` 实现
3. `orientation` 作为 init 参数

---

## 5. Avatar（头像）

**源文件**: `avatar.tsx` (113 行)  
**CSS**: 4 个 size 类 + fallback 类  
**复杂度**: ⭐⭐ 中等（6 个子组件）

### 3 种尺寸

| Size | CSS | Swift (pt) |
|---|---|---|
| `sm` | `size-6` | 24 × 24 |
| `default` | `size-8` | 32 × 32 |
| `lg` | `size-10` | 40 × 40 |

### 6 个子组件

| 子组件 | 功能 | 关键样式 |
|---|---|---|
| **Avatar** | 容器 | `rounded-full`, `after:inset-0 after:border after:border-border` |
| **AvatarImage** | 图片 | `aspect-square size-full object-cover` |
| **AvatarFallback** | 图片失败时的备选 | `flex items-center justify-center`, `bg-muted`, `text-muted-foreground`, `text-sm` |
| **AvatarBadge** | 右下角小圆点 | `absolute right-0 bottom-0`, `rounded-full`, `ring-2` |
| **AvatarGroup** | 头像组 | `-space-x-2` (重叠排列) |
| **AvatarGroupCount** | +N 计数 | `ring-2 ring-background` |

### 细节

- **AvatarFallback**: 在图片加载失败或为空时显示（通常放首字母）
- **AvatarBadge**: 随 Avatar size 自动缩放（sm: 8px, default: 10px, lg: 12px）
- **AvatarGroup**: 头像之间重叠 8pt（`-space-x-2`），每个头像有白色描边
- **AvatarGroupCount**: 文本居中，白色描边，通常放在 Group 末尾

### 结构

```
AvatarGroup
├── Avatar × N
│   ├── AvatarImage (AsyncImage / Image)
│   ├── AvatarFallback (Text, 无图片时显示)
│   └── AvatarBadge (可选)
└── AvatarGroupCount (可选, "+3")
```

### 移植关键点

1. `AvatarImage` → SwiftUI `AsyncImage` + `.clipShape(Circle())`
2. `AvatarFallback` → 默认显示首字母，`@ViewBuilder` 支持自定义
3. `AvatarBadge` → `.overlay(alignment: .bottomTrailing)` 实现
4. `AvatarGroup` → `HStack(spacing: -8)` + `.overlay(Circle().stroke(token.background, 2))`
5. `AvatarGroupCount` → 文本居中 + Circle clip + 描边

---

## 移植顺序建议

按复杂度递增 → 快速出效果：

```
Day 1-2:  Separator (30min) + Input (1h)      → 两个极简组件，成就感快
Day 3-4:  Badge (1h)                          → 6 variants 展示 variant 系统
Day 5-6:  Switch (2h)                         → 动画 + ToggleStyle
Day 7-9:  Avatar (4h)                         → 6 子组件，最复杂
```

## 通用移植原则（基于已完成 Button/Card 经验）

1. **first-class 参数优先**: 圆角/尺寸/颜色用 init 参数直接替换内部值
2. **customStyle 作为补充**: 特效/外框等用闭包追加
3. **Variant → enum**: 每个 variant 用 `switch/case` computed property 映射
4. **Token 映射**: `bg-primary` → `token.primary`, `text-muted-foreground` → `token.mutedForeground`
5. **过渡动画**: `transition-all 150ms` → `.animation(.easeInOut(duration: 0.15))`
6. **状态**: `disabled:opacity-50` → `@Environment(\.isEnabled)` + `.opacity(0.5)`
7. **Focus ring**: `focus-visible:ring-3` → `@FocusState` + 条件 `.overlay(RoundedRectangle.strokeBorder(token.ring, 3))`
