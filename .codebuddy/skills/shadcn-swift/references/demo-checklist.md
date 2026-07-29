# Demo App 更新清单

## 添加新组件到 Demo App 的步骤

### 1. 添加 @State 变量

在 `ComponentList` struct 中添加交互状态：

```swift
@State private var myComponentState = false
@State private var myComponentValue = ""
```

### 2. 在 LazyVGrid 中添加 section 调用

```swift
LazyVGrid(columns: columns, spacing: 16) {
    // ... 已有 sections
    section_myComponent  // 添加这里
}
```

### 3. 实现 section

```swift
@ViewBuilder private var section_myComponent: some View {
    GlassSection(title: "MyComponent") {
        VStack(spacing: 8) {
            // 组件预览
            MyComponent()
            // 交互按钮（如需触发弹窗）
            Button("Open") { showMyComponent = true }
                .shadcnButton(variant: .outline, size: .sm)
        }
    }
}
```

### 4. 更新主题选择器（如新增主题）

在 `ThemePicker` 和两个 `currentTheme` switch 中添加新 case。

### 5. 更新 preset 编解码（如新增主题）

更新 `themeIndex` 和 `themeFromIndex` 字典。注意 3 bits 最多支持 8 个主题。

## 禁止事项

- ❌ 不要在 Demo 中使用原生 SwiftUI 组件替代 shadcn 组件
  - 用 `ShadcnButton` / `.shadcnButton()` 而非 `Button`
  - 用 `Input` 而非 `TextField`
  - 用 `DropdownMenuItem` 而非 `Menu { Button }`
- ❌ 不要用 `.constant("")` 绑定交互组件（用 `@State`）
- ❌ 不要在 section 内部用 `.overlay` 显示弹窗（用 `.fullScreenCover` 或全局 overlay）

## Toast 全局化

Toast 必须放在根 View 层级，不能放在单个 section 内：

```swift
struct ContentView: View {
    @State private var toasts: [ToastItem] = []

    var body: some View {
        ZStack {
            TabView { ... }
            VStack { ToastView(toasts: $toasts) }
                .allowsHitTesting(false)
        }
    }
}
```

ComponentList 接收 `toasts` binding：
```swift
ComponentList(selectedTheme: $selectedTheme, toasts: $toasts)
```

## 组件 Section 模板

### 简单展示型
```swift
@ViewBuilder private var section_xxx: some View {
    GlassSection(title: "XXX") {
        VStack(spacing: 8) {
            XXX()
            XXX(variant: .secondary)
        }
    }
}
```

### 交互型（弹窗）
```swift
@ViewBuilder private var section_dialog: some View {
    GlassSection(title: "Dialog") {
        Button("Open Dialog") { showDialog = true }
            .shadcnButton(variant: .outline, size: .sm)
            .dialog(isPresented: $showDialog) {
                DialogContent {
                    DialogHeader {
                        DialogTitle("Title")
                        DialogDescription("Description")
                    }
                    DialogFooter {
                        Button("Cancel") { showDialog = false }.shadcnButton(variant: .outline, size: .sm)
                        Button("OK") { showDialog = false }.shadcnButton(size: .sm)
                    }
                }
            }
    }
}
```

### 列表型
```swift
@ViewBuilder private var section_variants: some View {
    GlassSection(title: "XXX Variants") {
        ForEach(XXXVariant.allCases, id: \.rawValue) { variant in
            HStack(spacing: 8) {
                Text(variant.rawValue.capitalized)
                    .font(.caption)
                    .frame(width: 60, alignment: .leading)
                    .foregroundStyle(.secondary)
                XXX(variant: variant) { Text(variant.rawValue.capitalized) }
            }
        }
    }
}
```
