# 组件模式参考

## 弹窗组件（Dialog/Sheet/Drawer/AlertDialog）

### fullScreenCover 模式

所有弹窗必须用 `.fullScreenCover` + `.presentationBackground(.clear)`：

```swift
public struct DialogModifier<Content: View>: ViewModifier {
    @Binding var isPresented: Bool
    @ViewBuilder let dialog: () -> Content

    public func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented) {
                ZStack {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture { isPresented = false }
                    dialog()
                        .transition(.scale(scale: 0.95).combined(with: .opacity))
                }
                .presentationBackground(.clear)
            }
    }
}
```

### Select 下拉模式

用 GeometryReader 获取触发元素位置，fullScreenCover 中定位下拉列表：

```swift
.fullScreenCover(isPresented: $isOpen) {
    ZStack(alignment: .top) {
        Color.black.opacity(0.3).ignoresSafeArea().onTapGesture { isOpen = false }
        ScrollView { ... }
            .padding(.top, triggerFrame.maxY + 4)  // 定位在触发元素下方
    }
    .presentationBackground(.clear)
}
```

## 容器组件（Card/Tabs/Accordion）

### Environment Action 模式

父子通信通过 Environment + Sendable Action struct：

```swift
struct ToggleAction: Sendable {
    let toggle: @Sendable (String) -> Void
}

// 父: 注入 action
.environment(\.toggleAction, ToggleAction { value in
    withAnimation { expanded.toggle(value) }
})

// 子: 调用 action
Button { toggleAction.toggle(value) } label: { ... }
```

## 表单组件（Input/Checkbox/Switch）

### suppressInputBorder 模式

Input 在 InputGroup 内时通过 Environment 隐藏自身边框：

```swift
@Environment(\.suppressInputBorder) private var suppressBorder

if suppressBorder {
    field  // 无边框
} else {
    field.clipShape(...).overlay(borderOverlay)
}

// InputGroup 注入
.environment(\.suppressInputBorder, true)
```

## 列表组件（Table/Item/Pagination）

### 修饰符模式

TableCell 用 ViewModifier 而非 View：

```swift
public struct TableCell: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
    }
}

public extension View {
    func tableCell() -> some View { modifier(TableCell()) }
}
```

## 聊天组件（Bubble/Message/MessageScroller）

### 对齐模式

start/end 对齐通过 HStack + Spacer 实现：

```swift
HStack {
    if align == .end { Spacer() }
    content()
    if align == .start { Spacer() }
}
```

## 尺寸映射表

| Tailwind | SwiftUI | 说明 |
|---|---|---|
| `h-8` | `.frame(height: 32)` | Input/Button default |
| `h-10` | `.frame(height: 40)` | Select trigger |
| `h-5` | `.frame(height: 20)` | Badge |
| `text-sm` | `.font(.system(size: 14))` | 正文 |
| `text-xs` | `.font(.system(size: 12))` | 辅助文字 |
| `text-lg` | `.font(.system(size: 18, weight: .semibold))` | 标题 |
| `px-2.5` | `.padding(.horizontal, 10)` | Input padding |
| `rounded-lg` | `cornerRadius: token.radius` (10pt) | 默认圆角 |
| `rounded-full` | `.clipShape(Capsule())` | 药丸形 |
| `gap-2` | `HStack(spacing: 8)` | 间距 |
| `transition-all 150ms` | `.animation(.easeInOut(duration: 0.15))` | 过渡 |
