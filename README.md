# ShadcnSwiftUI

将 [shadcn/ui](https://ui.shadcn.com) 设计系统移植到 Apple 平台（iOS 18+ / macOS 15+），使用 SwiftUI 原生实现。

源码可见、可复制、可定制 — 你拥有每一行代码。

## 安装

### Swift Package Manager

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/KallerIsaac10086/Shadcnui-Swift.git", from: "1.0.0")
]
```

或 Xcode: `File → Add Package Dependencies → 粘贴 URL`

### 手动复制

每个组件都是独立的 `.swift` 文件，直接复制 `shadcn-swift/Sources/ShadcnSwiftUI/Components/` 下的文件到你的项目即可。

## 快速开始

```swift
import ShadcnSwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .shadcnTheme(Themes.blue)
        }
    }
}

// 使用组件
Button("Click") { }
    .shadcnButton(variant: .outline, size: .sm)

Card {
    CardHeader {
        CardTitle("Title")
        CardDescription("Description")
    }
    CardContent { Text("Content") }
}

// 表单
ShadcnLabel("Email", required: true)
Input("Enter email", text: $email, type: .email)

// 弹窗
Button("Open") { showDialog = true }
    .dialog(isPresented: $showDialog) {
        DialogContent {
            DialogHeader {
                DialogTitle("Edit Profile")
                DialogDescription("Make changes here.")
            }
            DialogFooter {
                Button("Cancel") { showDialog = false }.shadcnButton(variant: .outline)
                Button("Save") { showDialog = false }.shadcnButton()
            }
        }
    }
```

## 组件清单（56 个）

### 基础

| 组件 | 说明 |
|---|---|
| Button | 6 variants, 8 sizes, `cornerRadius` + `customStyle` |
| ButtonGroup | 多按钮水平/垂直排列 |
| Card | 7 个子组件, `cornerRadius`/`borderWidth`/`borderColor` |
| Badge | 6 variants (default/secondary/destructive/outline/ghost/link) |
| Avatar | 3 sizes, 6 个子组件 (Image/Fallback/Badge/Group/GroupCount) |
| Separator | 水平/垂直分割线 |
| Typography | h1~h4, p, lead, muted, code, blockquote 预设 |

### 表单

| 组件 | 说明 |
|---|---|
| Input | 6 种 type (text/password/email/number/url/search), focus ring, invalid 态 |
| Textarea | 多行输入 + placeholder |
| Label | 表单标签, `required` 标识 |
| Switch | ToggleStyle, 2 sizes |
| Checkbox | checked/indeterminate 半选态 |
| RadioGroup | RadioGroup + RadioItem |
| Slider | 拖拽滑块, range/step |
| Toggle | 2 variants, 3 sizes |
| ToggleGroup | 多 Toggle 按钮组 |
| Select | 自定义下拉, Environment 自动选中 |
| NativeSelect | SwiftUI Menu 封装 |
| Combobox | 搜索 + 下拉过滤 |
| InputOTP | 验证码输入, paste 支持 |
| Field | Label + Input + Description + Error |
| InputGroup | Input 前缀/后缀 addon |

### 反馈

| 组件 | 说明 |
|---|---|
| Alert | default/destructive, Title/Description/Action |
| AlertDialog | 模态确认对话框 |
| Progress | determinate/indeterminate, color/label |
| Skeleton | 脉冲动画 |
| Spinner | 加载旋转器 |
| Toast | 4 种类型 (success/info/warning/error) |

### 浮层

| 组件 | 说明 |
|---|---|
| Dialog | 模态对话框, 5 种 size, `fullScreenCover` |
| Sheet | 四方向滑入面板 (top/bottom/leading/trailing) |
| Drawer | 底部抽屉, snap points, 拖拽关闭 |
| Tooltip | hover/long-press 提示, 3 sizes |
| Popover | 弹出卡片 + Title/Description |
| HoverCard | 悬停详情卡片 |

### 导航

| 组件 | 说明 |
|---|---|
| Tabs | default (pill) + line (underline) 两种 variant |
| Breadcrumb | Link/Page/Separator/Ellipsis |
| Pagination | Previous/Next/Link/Ellipsis |
| NavigationMenu | 水平导航栏 |
| Menubar | 桌面菜单栏 (File/Edit/...) |

### 数据展示

| 组件 | 说明 |
|---|---|
| Table | Header/Body/Footer/Row/Head/Cell |
| Accordion | single/multiple 展开模式 |
| Collapsible | 折叠面板 |
| Carousel | 滑动轮播 |
| Item | 列表行 (Media/Content/Title/Description/Actions) |
| Empty | 空状态 (Media/Title/Description/Content) |
| AspectRatio | 宽高比容器 |
| ScrollArea | 可滚动区域 |

### 菜单

| 组件 | 说明 |
|---|---|
| DropdownMenu | Item/Label/Separator/Shortcut/CheckboxItem |
| ContextMenu | 右键/长按菜单 |
| Command | ⌘K 命令面板 (Input/List/Group/Item/Empty) |

### 聊天

| 组件 | 说明 |
|---|---|
| Bubble | 聊天气泡, start/end 对齐 |
| Message | 消息行 (Avatar/Header/Content/Footer) |
| MessageScroller | 自动滚动消息列表 |
| Attachment | 文件附件 pill |
| Marker | 对话标记/分隔符 |

### 其他

| 组件 | 说明 |
|---|---|
| Kbd | 键盘按键 + KbdGroup |
| Direction | RTL/LTR 方向控制 |
| Resizable | 可拖拽面板组 |
| DatePicker | 日历选择器 |

## 主题系统

14 套内置主题，OKLCH 色彩空间，Light/Dark 自动切换：

```swift
// 内置主题
Themes.zinc       // 锌灰（默认）
Themes.neutral    // 中性灰
Themes.stone      // 石灰
Themes.red        // 红色
Themes.rose       // 玫红
Themes.orange     // 橙色
Themes.yellow     // 黄色
Themes.green      // 绿色
Themes.teal       // 青色
Themes.blue       // 蓝色
Themes.indigo     // 靛蓝
Themes.violet     // 紫罗兰
Themes.purple     // 紫色
Themes.pink       // 粉色

// 应用主题
ContentView()
    .shadcnTheme(Themes.blue)
```

## 自定义样式

两种方式互补：

```swift
// 1. First-class 参数 — 替换内部默认值
Button("Pill") { }.shadcnButton(cornerRadius: 999)
Card(cornerRadius: 24, borderWidth: 2, borderColor: .blue) { ... }

// 2. customStyle 闭包 — 追加 modifier
Button("Glow") { }
    .shadcnButton(variant: .default) { label in
        AnyView(label.shadow(color: .blue.opacity(0.5), radius: 8, y: 4))
    }
```

## 目录结构

```
├── Package.swift              # SPM 清单（根目录）
├── shadcn-swift/
│   ├── Sources/ShadcnSwiftUI/
│   │   ├── Theme/             # DesignToken + Theme + Themes + Environment
│   │   ├── Utils/             # Color+OKLCH
│   │   └── Components/        # 56 个组件
│   └── Tests/
├── ShadcnSwift/               # Demo App (Xcode)
│   └── ShadcnSwift/
│       └── ContentView.swift  # 全组件交互式预览
├── docs/                      # 设计文档 + 迁移计划
├── LICENSE                    # Apache 2.0
└── README.md
```

## 平台要求

- iOS 18+ / macOS 15+
- Swift 6.0
- Xcode 16+

## License

[Apache License 2.0](LICENSE)
