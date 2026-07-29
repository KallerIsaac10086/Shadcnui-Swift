import SwiftUI
import ShadcnSwiftUI

// MARK: - Root View

struct ContentView: View {
    @State private var selectedTheme = "zinc"
    @State private var toasts: [ToastItem] = []

    var body: some View {
        ZStack {
            TabView {
                ComponentList(selectedTheme: $selectedTheme, toasts: $toasts)
                    .tabItem {
                        Label("Components", systemImage: "square.grid.2x2")
                    }

                Customizer(selectedTheme: $selectedTheme)
                    .tabItem {
                        Label("Customizer", systemImage: "slider.horizontal.3")
                    }
            }
            .shadcnTheme(currentTheme)

            // Global toast overlay
            VStack {
                ToastView(toasts: $toasts)
            }
            .allowsHitTesting(false)
        }
    }

    private var currentTheme: Theme {
        switch selectedTheme {
        case "neutral": return Themes.neutral
        case "stone":   return Themes.stone
        case "red":     return Themes.red
        case "rose":    return Themes.rose
        case "orange":  return Themes.orange
        case "yellow":  return Themes.yellow
        case "green":   return Themes.green
        case "teal":    return Themes.teal
        case "blue":    return Themes.blue
        case "indigo":  return Themes.indigo
        case "violet":  return Themes.violet
        case "purple":  return Themes.purple
        case "pink":    return Themes.pink
        default:        return Themes.zinc
        }
    }
}

// MARK: - Shared Theme Picker

struct ThemePicker: View {
    @Binding var selectedTheme: String

    var body: some View {
        VStack(spacing: 8) {
            Picker("Theme", selection: $selectedTheme) {
                Text("Zinc").tag("zinc")
                Text("Neutral").tag("neutral")
                Text("Stone").tag("stone")
                Text("Red").tag("red")
                Text("Rose").tag("rose")
                Text("Orange").tag("orange")
                Text("Yellow").tag("yellow")
                Text("Green").tag("green")
                Text("Teal").tag("teal")
                Text("Blue").tag("blue")
                Text("Indigo").tag("indigo")
                Text("Violet").tag("violet")
                Text("Purple").tag("purple")
                Text("Pink").tag("pink")
            }
            .pickerStyle(.menu)
        }
    }
}

// MARK: - Glass Section Wrapper

struct GlassSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            content()
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Tab 1: Component List

struct ComponentList: View {
    @Environment(\.shadcnToken) private var token
    @Binding var selectedTheme: String
    @Binding var toasts: [ToastItem]

    @State private var switchDefault = false
    @State private var switchSm = false
    @State private var inputText = ""
    @State private var textareaText = ""
    @State private var checkbox1 = false
    @State private var checkbox2 = true
    @State private var radioSelection = "a"
    @State private var toggleBold = false
    @State private var toggleItalic = true

    // New component states
    @State private var sliderValue: Double = 0.5
    @State private var tabSelection = "account"
    @State private var showDialog = false
    @State private var showSheet = false
    @State private var showDrawer = false
    @State private var showAlertDialog = false
    @State private var showPopover = false
    @State private var selectValue = "light"
    @State private var comboboxQuery = ""
    @State private var comboboxSelection: String?
    @State private var carouselIndex = 0
    @State private var accordionExpanded = false
    @State private var paginationPage = 1
    @State private var dateValue = Date()
    @State private var nativeSelect = "light"
    @State private var commandText = ""
    @State private var otpCode = ""
    @State private var searchText = ""
    @State private var messageText = ""

    private let columns = [
        GridItem(.adaptive(minimum: 340, maximum: 480), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ThemePicker(selectedTheme: $selectedTheme)
                    .frame(maxWidth: 480)

                LazyVGrid(columns: columns, spacing: 16) {
                    section_buttons; section_toggle
                    section_badge; section_checkbox
                    section_radio; section_switch
                    section_input; section_textarea
                    section_progress; section_skeleton
                    section_alert; section_separator
                    section_avatar; section_card
                    // ── New components ──
                    section_slider; section_spinner
                    section_kbd; section_collapsible
                    section_accordion; section_tabs
                    section_breadcrumb; section_select
                    section_combobox; section_nativeSelect
                    section_dialog; section_sheet
                    section_drawer; section_alertDialog
                    section_tooltip; section_popover
                    section_hoverCard; section_dropdownMenu
                    section_contextMenu; section_carousel
                    section_pagination; section_empty
                    section_field; section_item
                    section_typography; section_aspectRatio
                    section_table; section_datePicker
                    section_buttonGroup; section_inputGroup
                    section_bubble; section_message
                    section_attachment; section_scrollArea
                    section_navigationMenu; section_menubar
                    section_toast; section_command
                    section_inputOTP; section_marker
                    section_messageScroller; section_resizable
                    section_direction; section_toggleGroup
                }
                .frame(maxWidth: 976)

                Spacer(minLength: 20)
            }
            .frame(maxWidth: .infinity)
            .padding(16)
        }
        .background(token.background.ignoresSafeArea())
    }

    @ViewBuilder private var section_buttons: some View {
        GlassSection(title: "Button Variants") {
            ForEach(ButtonVariant.allCases, id: \.rawValue) { variant in
                HStack(spacing: 8) {
                    Text(variant.rawValue.capitalized)
                        .font(.caption)
                        .frame(width: 60, alignment: .leading)
                        .foregroundStyle(.secondary)
                    Button("Button") { }
                        .shadcnButton(variant: variant)
                }
            }
            ForEach(ButtonSize.allCases, id: \.rawValue) { size in
                HStack(spacing: 8) {
                    Text(size.rawValue)
                        .font(.caption)
                        .frame(width: 60, alignment: .leading)
                        .foregroundStyle(.secondary)
                    Button("Btn") { }
                        .shadcnButton(size: size)
                }
            }
        }
    }

    @ViewBuilder private var section_badge: some View {
        GlassSection(title: "Badge") {
            ForEach(BadgeVariant.allCases, id: \.rawValue) { variant in
                HStack(spacing: 8) {
                    Text(variant.rawValue.capitalized)
                        .font(.caption)
                        .frame(width: 60, alignment: .leading)
                        .foregroundStyle(.secondary)
                    Badge(variant: variant) {
                        Text(variant.rawValue.capitalized)
                    }
                }
            }
        }
    }

    @ViewBuilder private var section_input: some View {
        GlassSection(title: "Input") {
            VStack(spacing: 10) {
                InputStateDemo()
                Input("Disabled", text: .constant("Can't edit"))
                    .disabled(true)
            }
        }
        .environment(\.shadcnToken, token)
    }

    @ViewBuilder private var section_switch: some View {
        GlassSection(title: "Switch") {
            HStack(spacing: 24) {
                switch_item(title: "default", isOn: $switchDefault, style: .shadcnSwitch)
                switch_item(title: "sm", isOn: $switchSm, style: ShadcnSwitchStyle(size: .sm))
            }
        }
    }

    private func switch_item(title: String, isOn: Binding<Bool>, style: some ToggleStyle) -> some View {
        VStack(spacing: 4) {
            Toggle("", isOn: isOn)
                .toggleStyle(style)
                .labelsHidden()
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder private var section_separator: some View {
        GlassSection(title: "Separator") {
            VStack(spacing: 12) {
                Text("Above").font(.caption).foregroundStyle(.secondary)
                Separator()
                Text("Below").font(.caption).foregroundStyle(.secondary)
                HStack(spacing: 8) {
                    Text("L").font(.caption2).foregroundStyle(.secondary)
                    Separator(orientation: .vertical).frame(height: 20)
                    Text("R").font(.caption2).foregroundStyle(.secondary)
                }
            }
        }
    }

    @ViewBuilder private var section_avatar: some View {
        GlassSection(title: "Avatar") {
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Avatar(size: .sm) { AvatarFallback(initials: "S") }
                    Avatar(size: .default) { AvatarFallback(initials: "M") }
                    Avatar(size: .lg) { AvatarFallback(initials: "L") }
                }
                ZStack(alignment: .bottomTrailing) {
                    Avatar(size: .lg) { AvatarFallback(initials: "JD") }
                    AvatarBadge(size: .lg)
                }
                AvatarGroup {
                    ForEach(["A", "B", "C"], id: \.self) { i in
                        Avatar(size: .sm) { AvatarFallback(initials: i) }
                    }
                    AvatarGroupCount(5)
                }
            }
        }
    }

    @ViewBuilder private var section_card: some View {
        GlassSection(title: "Card") {
            Card {
                CardHeader {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            CardTitle("Notifications")
                            CardDescription("You have 3 unread messages.")
                        }
                        Spacer()
                        Button { } label: {
                            Image(systemName: "bell.badge")
                        }
                        .shadcnButton(variant: .ghost, size: .iconSm)
                    }
                }
                CardContent {
                    Text("Your subscription renews on August 1, 2026.")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }
                CardFooter {
                    Button("Dismiss") { }.shadcnButton(variant: .outline, size: .sm)
                    Button("View All") { }.shadcnButton(variant: .default, size: .sm)
                }
            }
        }
    }

    @ViewBuilder private var section_toggle: some View {
        GlassSection(title: "Toggle") {
            HStack(spacing: 8) {
                ShadcnToggle(isPressed: $toggleBold) {
                    Image(systemName: "bold").frame(width: 16, height: 16)
                }
                ShadcnToggle(variant: .outline, isPressed: $toggleItalic) {
                    Image(systemName: "italic").frame(width: 16, height: 16)
                }
                ShadcnToggle(size: .sm, isPressed: .constant(false)) {
                    Image(systemName: "underline").frame(width: 14, height: 14)
                }
            }
        }
    }

    @ViewBuilder private var section_checkbox: some View {
        GlassSection(title: "Checkbox") {
            HStack(spacing: 16) {
                HStack(spacing: 6) { Checkbox(isChecked: $checkbox1); Text("Option A").font(.system(size: 14)) }
                HStack(spacing: 6) { Checkbox(isChecked: $checkbox2); Text("Option B").font(.system(size: 14)) }
            }
        }
    }

    @ViewBuilder private var section_radio: some View {
        GlassSection(title: "Radio Group") {
            RadioGroup(selection: $radioSelection) {
                RadioItem("iOS", value: "a")
                RadioItem("macOS", value: "b")
                RadioItem("watchOS", value: "c")
            }
        }
    }

    @ViewBuilder private var section_textarea: some View {
        GlassSection(title: "Textarea") {
            Textarea("Write something…", text: $textareaText, minHeight: 64)
        }
    }

    @ViewBuilder private var section_progress: some View {
        GlassSection(title: "Progress") {
            VStack(spacing: 8) {
                Progress(value: 0.65)
                Progress(value: 0.3)
            }
        }
    }

    @ViewBuilder private var section_skeleton: some View {
        GlassSection(title: "Skeleton") {
            VStack(spacing: 8) {
                Skeleton().frame(height: 16)
                Skeleton().frame(height: 16)
                Skeleton().frame(width: 120, height: 16)
            }
        }
    }

    @ViewBuilder private var section_alert: some View {
        GlassSection(title: "Alert") {
            Alert {
                AlertTitle("Success")
                AlertDescription("Your changes have been saved.")
            }
            Alert(variant: .destructive) {
                AlertTitle("Error")
                AlertDescription("Something went wrong.")
            }
            AlertAction {
                Button("Retry") { }.shadcnButton(variant: .outline, size: .sm)
            }
        }
    }

    // MARK: - New Component Sections

    @ViewBuilder private var section_slider: some View {
        GlassSection(title: "Slider") {
            VStack(spacing: 8) {
                Text(String(format: "%.1f", sliderValue)).font(.caption).foregroundStyle(.secondary)
                Slider(value: $sliderValue, in: 0...1, step: 0.1)
            }
        }
    }

    @ViewBuilder private var section_spinner: some View {
        GlassSection(title: "Spinner") {
            HStack(spacing: 24) {
                Spinner()
                Spinner().frame(width: 24, height: 24)
                Spinner().frame(width: 32, height: 32)
            }
        }
    }

    @ViewBuilder private var section_kbd: some View {
        GlassSection(title: "Kbd") {
            VStack(spacing: 8) {
                KbdGroup { Kbd("⌘"); Kbd("K") }
                HStack(spacing: 4) { Kbd("⌥"); Text("+").font(.caption); Kbd("Tab") }
            }
        }
    }

    @ViewBuilder private var section_collapsible: some View {
        GlassSection(title: "Collapsible") {
            Collapsible {
                Text("Show details").font(.system(size: 14, weight: .medium))
            } content: {
                Text("Hidden content revealed on tap.").font(.system(size: 14)).foregroundStyle(.secondary)
            }
        }
    }

    @ViewBuilder private var section_accordion: some View {
        GlassSection(title: "Accordion") {
            Accordion(type: .single) {
                AccordionItem(value: "1") {
                    AccordionTrigger("Is it accessible?", value: "1")
                    AccordionContent(value: "1") {
                        Text("Yes. Built on SwiftUI.").font(.system(size: 14)).foregroundStyle(.secondary).padding(.bottom, 12)
                    }
                }
                AccordionItem(value: "2") {
                    AccordionTrigger("Is it themed?", value: "2")
                    AccordionContent(value: "2") {
                        Text("Yes. Follows DesignToken.").font(.system(size: 14)).foregroundStyle(.secondary).padding(.bottom, 12)
                    }
                }
            }
        }
    }

    @ViewBuilder private var section_tabs: some View {
        GlassSection(title: "Tabs") {
            VStack(spacing: 8) {
                Tabs(selection: $tabSelection) {
                    TabsList {
                        TabsTrigger("Account", value: "account")
                        TabsTrigger("Password", value: "password")
                        TabsTrigger("Settings", value: "settings")
                    }
                    TabsContent(value: "account") { Text("Account tab content").font(.system(size: 14)).padding(.top, 8) }
                    TabsContent(value: "password") { Text("Password tab content").font(.system(size: 14)).padding(.top, 8) }
                    TabsContent(value: "settings") { Text("Settings tab content").font(.system(size: 14)).padding(.top, 8) }
                }
                Tabs(selection: $tabSelection) {
                    TabsList(variant: .line) {
                        TabsTrigger("Account", value: "account", variant: .line)
                        TabsTrigger("Password", value: "password", variant: .line)
                    }
                }
            }
        }
    }

    @ViewBuilder private var section_breadcrumb: some View {
        GlassSection(title: "Breadcrumb") {
            Breadcrumb {
                BreadcrumbItem { BreadcrumbLink("Home") }
                BreadcrumbSeparator()
                BreadcrumbItem { BreadcrumbLink("Products") }
                BreadcrumbSeparator()
                BreadcrumbItem { BreadcrumbPage("Current") }
            }
        }
    }

    @ViewBuilder private var section_select: some View {
        GlassSection(title: "Select") {
            Select(placeholder: "Theme", selection: $selectValue) {
                SelectItem("Light", value: "light")
                SelectItem("Dark", value: "dark")
                SelectItem("System", value: "system")
            }
        }
    }

    @ViewBuilder private var section_combobox: some View {
        GlassSection(title: "Combobox") {
            let fruits = ["Apple", "Banana", "Blueberry", "Cherry", "Grape", "Mango", "Orange", "Peach", "Strawberry"]
            let filtered = comboboxQuery.isEmpty ? fruits : fruits.filter { $0.lowercased().contains(comboboxQuery.lowercased()) }
            Combobox(query: $comboboxQuery, selection: $comboboxSelection, items: filtered)
        }
    }

    @ViewBuilder private var section_nativeSelect: some View {
        GlassSection(title: "NativeSelect") {
            if #available(iOS 16.0, macOS 13.0, *) {
                NativeSelect(placeholder: "Theme", selection: $nativeSelect, options: [("Light", "light"), ("Dark", "dark"), ("System", "system")])
            }
        }
    }

    @ViewBuilder private var section_dialog: some View {
        GlassSection(title: "Dialog") {
            VStack(spacing: 8) {
                Button("Open Dialog") { showDialog = true }.shadcnButton(variant: .outline, size: .sm)
            }
            .dialog(isPresented: $showDialog) {
                DialogContent(size: .sm) {
                    DialogHeader {
                        DialogTitle("Edit Profile")
                        DialogDescription("Make changes to your profile here.")
                    }
                    DialogFooter {
                        Button("Cancel") { showDialog = false }.shadcnButton(variant: .outline, size: .sm)
                        Button("Save") { showDialog = false }.shadcnButton(size: .sm)
                    }
                }
            }
        }
    }

    @ViewBuilder private var section_sheet: some View {
        GlassSection(title: "Sheet") {
            Button("Open Sheet") { showSheet = true }.shadcnButton(variant: .outline, size: .sm)
                .sheetOverlay(isPresented: $showSheet, side: .bottom) {
                    SheetContent {
                        SheetHeader {
                            SheetTitle("Sheet Title")
                            SheetDescription("This is a sheet panel.")
                        }
                        SheetFooter {
                            Button("Close") { showSheet = false }.shadcnButton(size: .sm)
                        }
                    }
                }
        }
    }

    @ViewBuilder private var section_drawer: some View {
        GlassSection(title: "Drawer") {
            Button("Open Drawer") { showDrawer = true }.shadcnButton(variant: .outline, size: .sm)
                .drawer(isPresented: $showDrawer, snapPoints: [0.4]) {
                    DrawerContent {
                        DrawerHeader {
                            DrawerTitle("Drawer")
                            DrawerDescription("Swipe down to dismiss.")
                        }
                        DrawerFooter {
                            Button("Close") { showDrawer = false }.shadcnButton(size: .sm)
                        }
                    }
                }
        }
    }

    @ViewBuilder private var section_alertDialog: some View {
        GlassSection(title: "AlertDialog") {
            Button("Delete") { showAlertDialog = true }.shadcnButton(variant: .destructive, size: .sm)
                .alertDialog(isPresented: $showAlertDialog, size: .sm) {
                    AlertDialogHeader {
                        AlertDialogTitle("Delete Chat")
                        AlertDialogDescription("This action is permanent and cannot be undone.")
                    }
                    AlertDialogFooter {
                        AlertDialogCancel { showAlertDialog = false }
                        AlertDialogAction("Delete", variant: .destructive) { showAlertDialog = false }
                    }
                }
        }
    }

    @ViewBuilder private var section_tooltip: some View {
        GlassSection(title: "Tooltip") {
            HStack(spacing: 16) {
                Text("Hover/Long-press").font(.system(size: 14)).padding(8).background(token.muted).clipShape(RoundedRectangle(cornerRadius: 6))
                    .tooltip("This is a tooltip", size: .default)
            }
        }
    }

    @ViewBuilder private var section_popover: some View {
        GlassSection(title: "Popover") {
            Button("Toggle Popover") { showPopover.toggle() }.shadcnButton(variant: .outline, size: .sm)
                .popover(isPresented: $showPopover) {
                    PopoverContent {
                        PopoverTitle("Notifications")
                        PopoverDescription("You have 3 new messages.")
                    }
                }
        }
    }

    @ViewBuilder private var section_hoverCard: some View {
        GlassSection(title: "HoverCard") {
            Text("Hover me").font(.system(size: 14)).padding(8).background(token.muted).clipShape(RoundedRectangle(cornerRadius: 6))
                .hoverCard {
                    HoverCardContent {
                        Text("More details here").font(.system(size: 14))
                        Text("Additional context").font(.system(size: 12)).foregroundStyle(.secondary)
                    }
                }
        }
    }

    @ViewBuilder private var section_dropdownMenu: some View {
        GlassSection(title: "Dropdown Menu") {
            DropdownMenu { }
                .overlay(alignment: .top) {
                    Menu {
                        DropdownMenuContent {
                            DropdownMenuLabel("Account")
                            DropdownMenuItem("Profile") {}
                            DropdownMenuItem("Settings") {}
                            DropdownMenuSeparator()
                            DropdownMenuItem("Logout", variant: .destructive) {}
                        }
                    } label: {
                        Text("Open Menu").font(.system(size: 14, weight: .medium))
                            .padding(.horizontal, 12).padding(.vertical, 6)
                            .background(token.card)
                            .clipShape(RoundedRectangle(cornerRadius: token.radius))
                            .overlay(RoundedRectangle(cornerRadius: token.radius).strokeBorder(token.border, lineWidth: 1))
                    }
                }
        }
    }

    @ViewBuilder private var section_contextMenu: some View {
        GlassSection(title: "ContextMenu") {
            Text("Long-press or right-click")
                .font(.system(size: 14))
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(token.card)
                .clipShape(RoundedRectangle(cornerRadius: token.radius))
                .overlay(RoundedRectangle(cornerRadius: token.radius).strokeBorder(token.border, lineWidth: 1))
                .shadcnContextMenu {
                    ContextMenuItem("Copy") { toasts.append(ToastItem(title: "Copied!", type: .success)) }
                    ContextMenuItem("Share") { toasts.append(ToastItem(title: "Shared!", type: .info)) }
                    ContextMenuSeparator()
                    ContextMenuItem("Delete", variant: .destructive) { toasts.append(ToastItem(title: "Deleted", type: .error)) }
                }
        }
    }

    @ViewBuilder private var section_carousel: some View {
        GlassSection(title: "Carousel") {
            Carousel {
                ForEach(0..<3, id: \.self) { i in
                    CarouselItem(index: i) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill([Color.blue, Color.green, Color.orange][i].opacity(0.3))
                            .frame(height: 100)
                            .overlay {
                                VStack(spacing: 4) {
                                    Text("Page \(i + 1)").font(.headline)
                                    Text("Swipe to navigate").font(.caption).foregroundStyle(.secondary)
                                }
                            }
                    }
                }
            }
            .frame(height: 140)
        }
    }

    @ViewBuilder private var section_pagination: some View {
        GlassSection(title: "Pagination") {
            Pagination {
                PaginationPrevious(action: { if paginationPage > 1 { paginationPage -= 1 } }, disabled: paginationPage <= 1)
                PaginationLink(page: 1, isActive: paginationPage == 1) { paginationPage = 1 }
                PaginationLink(page: 2, isActive: paginationPage == 2) { paginationPage = 2 }
                PaginationLink(page: 3, isActive: paginationPage == 3) { paginationPage = 3 }
                PaginationNext(action: { if paginationPage < 3 { paginationPage += 1 } }, disabled: paginationPage >= 3)
            }
        }
    }

    @ViewBuilder private var section_empty: some View {
        GlassSection(title: "Empty State") {
            Empty {
                EmptyHeader {
                    EmptyMedia(icon: Image(systemName: "tray"))
                    EmptyTitle("No items")
                    EmptyDescription("Get started by creating your first item.")
                }
                EmptyContent {
                    Button("Add Item") { }.shadcnButton(size: .sm)
                }
            }
            .frame(height: 200)
        }
    }

    @ViewBuilder private var section_field: some View {
        GlassSection(title: "Field") {
            Field(isInvalid: !messageText.isEmpty && !messageText.contains("@")) {
                FieldLabel("Email", required: true)
                Input("Enter email", text: $messageText, type: .email)
                FieldDescription("We'll never share your email.")
                FieldError(!messageText.isEmpty && !messageText.contains("@") ? "Enter a valid email." : "")
            }
        }
    }

    @ViewBuilder private var section_item: some View {
        GlassSection(title: "Item") {
            VStack(spacing: 8) {
                Item {
                    ItemMedia { Image(systemName: "person.circle.fill").font(.system(size: 28)).foregroundColor(token.mutedForeground) }
                    ItemContent { ItemTitle("John Doe"); ItemDescription("john@example.com") }
                    ItemActions { Image(systemName: "chevron.right").font(.system(size: 14)).foregroundColor(token.mutedForeground) }
                }
            }
        }
    }

    @ViewBuilder private var section_typography: some View {
        GlassSection(title: "Typography") {
            VStack(alignment: .leading, spacing: 4) {
                Typography.h1("Heading 1")
                Typography.lead("A lead paragraph with muted style.")
                Typography.p("Regular paragraph text.")
                Typography.code("print(\"hello\")")
                Typography.muted("Muted small text.")
            }
        }
    }

    @ViewBuilder private var section_aspectRatio: some View {
        GlassSection(title: "AspectRatio") {
            AspectRatio(16/9) {
                Color.blue.opacity(0.2).overlay(Text("16:9")).clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }

    @ViewBuilder private var section_table: some View {
        GlassSection(title: "Table") {
            Table {
                TableHeader {
                    TableRow { TableHead("Name"); TableHead("Status"); TableHead("Role") }
                }
                TableBody {
                    TableRow {
                        Text("John").tableCell()
                        Badge(variant: .default) { Text("Active") }.tableCell()
                        Text("Admin").tableCell()
                    }
                    TableRow {
                        Text("Jane").tableCell()
                        Badge(variant: .secondary) { Text("Inactive") }.tableCell()
                        Text("User").tableCell()
                    }
                }
            }
        }
    }

    @ViewBuilder private var section_datePicker: some View {
        GlassSection(title: "DatePicker") {
            if #available(iOS 16.0, macOS 13.0, *) {
                ShadcnDatePicker("Date", selection: $dateValue)
            }
        }
    }

    @ViewBuilder private var section_buttonGroup: some View {
        GlassSection(title: "ButtonGroup") {
            VStack(spacing: 8) {
                ButtonGroup {
                    Button("One") { }.shadcnButton(variant: .outline, size: .sm)
                    Button("Two") { }.shadcnButton(variant: .outline, size: .sm)
                    Button("Three") { }.shadcnButton(variant: .outline, size: .sm)
                }
                ButtonGroup(orientation: .vertical) {
                    Button("Top") { }.shadcnButton(variant: .outline, size: .sm)
                    Button("Bottom") { }.shadcnButton(variant: .outline, size: .sm)
                }
            }
        }
    }

    @ViewBuilder private var section_inputGroup: some View {
        GlassSection(title: "InputGroup") {
            InputGroup {
                InputGroupAddon(align: .inlineStart) { InputGroupText("$") }
                Input("Amount", text: $searchText)
                InputGroupAddon(align: .inlineEnd) { InputGroupText(".00") }
            }
        }
    }

    @ViewBuilder private var section_bubble: some View {
        GlassSection(title: "Bubble") {
            VStack(spacing: 8) {
                Bubble(align: .start) { BubbleContent("Hello! How can I help?") }
                Bubble(align: .end) { BubbleContent("I have a question.") }
            }
        }
    }

    @ViewBuilder private var section_message: some View {
        GlassSection(title: "Message") {
            VStack(spacing: 12) {
                Message(align: .start) {
                    MessageAvatar { Avatar(size: .sm) { AvatarFallback(initials: "JD") } }
                    MessageContent {
                        MessageHeader { Text("John").font(.system(size: 13, weight: .medium)); Text("2m ago").font(.system(size: 11)).foregroundStyle(.secondary) }
                        Bubble(align: .start) { BubbleContent("Hey, how are you?") }
                    }
                }
                Message(align: .end) {
                    MessageContent {
                        Bubble(align: .end) { BubbleContent("I'm good, thanks!") }
                    }
                }
            }
        }
    }

    @ViewBuilder private var section_attachment: some View {
        GlassSection(title: "Attachment") {
            Attachment {
                AttachmentMedia { Image(systemName: "doc.text.fill").font(.system(size: 24)).foregroundColor(token.primary) }
                AttachmentContent {
                    AttachmentTitle("report.pdf")
                    AttachmentDescription("PDF · 2.4 MB")
                }
                AttachmentActions { AttachmentAction {} }
            }
        }
    }

    @ViewBuilder private var section_scrollArea: some View {
        GlassSection(title: "ScrollArea") {
            ScrollArea {
                VStack(spacing: 4) {
                    ForEach(0..<8, id: \.self) { i in
                        Text("Scrollable row \(i + 1)").font(.system(size: 14)).padding(8).frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .frame(height: 120)
        }
    }

    @ViewBuilder private var section_navigationMenu: some View {
        GlassSection(title: "NavigationMenu") {
            NavigationMenu {
                NavigationMenuList {
                    NavigationMenuItem("Home") {}
                    NavigationMenuItem("Products") {}
                    NavigationMenuItem("About") {}
                }
            }
        }
    }

    @ViewBuilder private var section_menubar: some View {
        GlassSection(title: "Menubar") {
            Menubar {
                MenubarMenu("File") {
                    MenubarItem("New") {}
                    MenubarItem("Open") {}
                    MenubarSeparator()
                    MenubarItem("Quit", variant: .destructive) {}
                }
                MenubarMenu("Edit") {
                    MenubarItem("Copy") {}
                    MenubarItem("Paste") {}
                }
            }
        }
    }

    @ViewBuilder private var section_toast: some View {
        GlassSection(title: "Toast") {
            VStack(spacing: 8) {
                Button("Show Success") { toasts.append(ToastItem(title: "Saved", description: "Your changes have been saved.", type: .success)) }.shadcnButton(variant: .outline, size: .sm)
                Button("Show Error") { toasts.append(ToastItem(title: "Error", description: "Something went wrong.", type: .error)) }.shadcnButton(variant: .outline, size: .sm)
            }
        }
    }

    @ViewBuilder private var section_command: some View {
        GlassSection(title: "Command") {
            VStack(spacing: 8) {
                CommandDialog {
                    CommandInput(placeholder: "Type a command...", text: $commandText)
                    CommandList {
                        CommandGroup(heading: "Actions") {
                            CommandItem("New File", shortcut: "⌘N") {}
                            CommandItem("Open...", shortcut: "⌘O") {}
                            CommandItem("Save", shortcut: "⌘S") {}
                        }
                        if !commandText.isEmpty {
                            CommandEmpty("No results for \"\(commandText)\"")
                        }
                    }
                }
                if !commandText.isEmpty {
                    Button("Clear") { commandText = "" }.shadcnButton(variant: .ghost, size: .xs)
                }
            }
        }
    }

    @ViewBuilder private var section_inputOTP: some View {
        GlassSection(title: "InputOTP") {
            VStack(spacing: 6) {
                InputOTP(code: $otpCode, length: 6)
                Text(otpCode.isEmpty ? "Enter code" : otpCode).font(.caption).foregroundStyle(.secondary)
            }
        }
    }

    @ViewBuilder private var section_marker: some View {
        GlassSection(title: "Marker") {
            VStack(spacing: 8) {
                Marker("Today", variant: .separator)
                Marker("System: switched branch", variant: .border)
                Marker("Thinking...")
            }
        }
    }

    @ViewBuilder private var section_messageScroller: some View {
        GlassSection(title: "MessageScroller") {
            MessageScroller {
                Message(align: .start) {
                    MessageContent {
                        MessageHeader { Text("System").font(.system(size: 13, weight: .medium)) }
                        Bubble(align: .start) { BubbleContent("Auto-scroll to bottom on new messages.") }
                    }
                }
            }
            .frame(height: 120)
        }
    }

    @ViewBuilder private var section_resizable: some View {
        GlassSection(title: "Resizable") {
            ResizablePanelGroup(orientation: .horizontal) {
                ResizablePanel(minSize: 80) {
                    Text("Left").font(.system(size: 14)).frame(maxWidth: .infinity, maxHeight: .infinity).background(token.muted).clipShape(RoundedRectangle(cornerRadius: 6))
                }
                ResizableHandle()
                ResizablePanel { Text("Right").font(.system(size: 14)).frame(maxWidth: .infinity, maxHeight: .infinity).background(token.muted.opacity(0.5)).clipShape(RoundedRectangle(cornerRadius: 6)) }
            }
            .frame(height: 80)
        }
    }

    @ViewBuilder private var section_direction: some View {
        GlassSection(title: "Direction") {
            DirectionProvider(direction: .rtl) {
                Text("RTL text example").font(.system(size: 14))
            }
        }
    }

    @ViewBuilder private var section_toggleGroup: some View {
        GlassSection(title: "ToggleGroup") {
            HStack(spacing: 8) {
                ShadcnToggle(isPressed: .constant(true)) { Image(systemName: "bold").frame(width: 14) }
                ShadcnToggle(isPressed: .constant(false)) { Image(systemName: "italic").frame(width: 14) }
                ShadcnToggle(isPressed: .constant(true)) { Image(systemName: "underline").frame(width: 14) }
            }
        }
    }
}

// MARK: - Tab 2: Customizer

struct Customizer: View {
    @Environment(\.shadcnToken) private var token
    @Binding var selectedTheme: String

    @State private var customVariant: ButtonVariant = .default
    @State private var cornerRadius: Double = 0
    @State private var isFullWidth = false
    @State private var shadowRadius: Double = 0
    @State private var buttonLabel = "Customize Me"

    @State private var cardCorner: Double = 15
    @State private var cardBorderWidth: Double = 1
    @State private var cardShowCustomBorder = false

    @State private var presetInput = ""
    @State private var presetCode = ""
    @State private var showCopiedToast = false

    private var currentTheme: Theme {
        switch selectedTheme {
        case "neutral": return Themes.neutral
        case "stone":   return Themes.stone
        case "red":     return Themes.red
        case "rose":    return Themes.rose
        case "orange":  return Themes.orange
        case "yellow":  return Themes.yellow
        case "green":   return Themes.green
        case "teal":    return Themes.teal
        case "blue":    return Themes.blue
        case "indigo":  return Themes.indigo
        case "violet":  return Themes.violet
        case "purple":  return Themes.purple
        case "pink":    return Themes.pink
        default:        return Themes.zinc
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ThemePicker(selectedTheme: $selectedTheme)
                    .frame(maxWidth: 480)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 340, maximum: 480), spacing: 16)], spacing: 16) {

                // ── Button Customizer ──
                GlassSection(title: "Button Customizer") {
                    VStack(spacing: 14) {
                        // Variant
                        HStack {
                            Text("Variant")
                                .font(.caption)
                                .frame(width: 80, alignment: .leading)
                                .foregroundStyle(.secondary)
                            Picker("", selection: $customVariant) {
                                ForEach(ButtonVariant.allCases, id: \.rawValue) { v in
                                    Text(v.rawValue.capitalized).tag(v)
                                }
                            }
                            .pickerStyle(.segmented)
                        }

                        // Corner radius
                        VStack(spacing: 4) {
                            HStack {
                                Text("Corner")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(cornerRadius == 0 ? "default" : "\(Int(cornerRadius))pt")
                                    .font(.caption.monospacedDigit())
                                    .foregroundStyle(.secondary)
                            }
                            Slider(value: $cornerRadius, in: 0...50, step: 1)
                                .tint(currentTheme.light.primary)
                        }

                        // Shadow
                        VStack(spacing: 4) {
                            HStack {
                                Text("Shadow")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("\(Int(shadowRadius))pt")
                                    .font(.caption.monospacedDigit())
                                    .foregroundStyle(.secondary)
                            }
                            Slider(value: $shadowRadius, in: 0...20, step: 1)
                                .tint(currentTheme.light.primary)
                        }

                        Toggle("Full width", isOn: $isFullWidth)
                            .font(.caption)

                        HStack {
                            Text("Label")
                                .font(.caption)
                                .frame(width: 80, alignment: .leading)
                                .foregroundStyle(.secondary)
                            TextField("", text: $buttonLabel)
                                .textFieldStyle(GlassTextFieldStyle())
                                .font(.system(size: 14))
                        }

                        // Live preview
                        HStack {
                            Text("Preview")
                                .font(.caption)
                                .frame(width: 80, alignment: .leading)
                                .foregroundStyle(.secondary)
                            Button(buttonLabel) { }
                                .shadcnButton(
                                    variant: customVariant,
                                    size: .default,
                                    cornerRadius: cornerRadius > 0 ? cornerRadius : nil
                                ) { label in
                                    var view: AnyView = label
                                    if isFullWidth {
                                        view = AnyView(view.frame(maxWidth: .infinity))
                                    }
                                    if shadowRadius > 0 {
                                        view = AnyView(view.shadow(
                                            color: currentTheme.light.primary.opacity(0.35),
                                            radius: shadowRadius,
                                            y: shadowRadius / 2
                                        ))
                                    }
                                    return view
                                }
                        }
                    }
                }

                // ── Card Customizer ──
                GlassSection(title: "Card Customizer") {
                    VStack(spacing: 14) {
                        VStack(spacing: 4) {
                            HStack {
                                Text("Corner")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("\(Int(cardCorner))pt")
                                    .font(.caption.monospacedDigit())
                                    .foregroundStyle(.secondary)
                            }
                            Slider(value: $cardCorner, in: 0...40, step: 1)
                                .tint(currentTheme.light.primary)
                        }

                        VStack(spacing: 4) {
                            HStack {
                                Text("Border")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(String(format: "%.0f", cardBorderWidth) + "pt")
                                    .font(.caption.monospacedDigit())
                                    .foregroundStyle(.secondary)
                            }
                            Slider(value: $cardBorderWidth, in: 0...6, step: 0.5)
                                .tint(currentTheme.light.primary)
                        }

                        Toggle("Colored border", isOn: $cardShowCustomBorder)
                            .font(.caption)

                        Card(
                            cornerRadius: cardCorner,
                            borderWidth: cardBorderWidth,
                            borderColor: cardShowCustomBorder ? currentTheme.light.primary : nil
                        ) {
                            CardHeader {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        CardTitle("Interactive Card")
                                        CardDescription("Adjust the sliders above.")
                                    }
                                    Spacer()
                                }
                            }
                            CardContent {
                                HStack(spacing: 16) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Corner: \(Int(cardCorner))pt")
                                        Text("Border: \(String(format: "%.1f", cardBorderWidth))pt")
                                    }
                                    .font(.system(size: 13))
                                    .foregroundStyle(.secondary)
                                    Spacer()
                                    Circle()
                                        .fill(cardShowCustomBorder ? currentTheme.light.primary : .clear)
                                        .frame(width: 24, height: 24)
                                        .overlay(Circle().strokeBorder(currentTheme.light.border, lineWidth: 1))
                                }
                            }
                            CardFooter {
                                Button("Reset") {
                                    cardCorner = 15
                                    cardBorderWidth = 1
                                    cardShowCustomBorder = false
                                }
                                .shadcnButton(variant: .outline, size: .sm)
                            }
                        }
                    }
                }

                // ── Share / Load Preset ──
                GlassSection(title: "Share Preset") {
                    VStack(spacing: 10) {
                        // Share
                        HStack(spacing: 8) {
                            Text(presetCode.isEmpty ? "Tap to generate…" : presetCode)
                                .font(.system(size: 13, design: .monospaced))
                                .foregroundStyle(presetCode.isEmpty ? .secondary : .primary)
                                .lineLimit(1)
                                .truncationMode(.middle)
                            Spacer()
                            Button {
                                presetCode = encodePreset()
                                #if os(macOS)
                                NSPasteboard.general.clearContents()
                                NSPasteboard.general.setString(presetCode, forType: .string)
                                #else
                                UIPasteboard.general.string = presetCode
                                #endif
                                showCopiedToast = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    showCopiedToast = false
                                }
                            } label: {
                                Image(systemName: showCopiedToast ? "checkmark" : "doc.on.doc")
                                    .font(.system(size: 13))
                            }
                            .shadcnButton(variant: .ghost, size: .iconXs)
                        }

                        // Load
                        HStack(spacing: 8) {
                            TextField("Paste preset code", text: $presetInput)
                                .textFieldStyle(GlassTextFieldStyle())
                                .font(.system(size: 13, design: .monospaced))
                                .autocorrectionDisabled()
                                #if !os(macOS)
                                .textInputAutocapitalization(.never)
                                #endif
                            Button("Apply") { applyPreset(presetInput) }
                                .shadcnButton(variant: .outline, size: .xs)
                                .disabled(presetInput.isEmpty)
                        }
                    }
                }
                } // end LazyVGrid

                Spacer(minLength: 20)
            }
            .frame(maxWidth: .infinity)
            .padding(16)
        }
        .background(token.background.ignoresSafeArea())
    }

    // MARK: - Preset Encode / Decode

    private let themeIndex: [String: UInt8] = ["zinc":0, "neutral":1, "stone":2, "rose":3, "orange":4, "green":5, "blue":6, "violet":7]
    private let themeFromIndex: [UInt8: String] = [0:"zinc", 1:"neutral", 2:"stone", 3:"rose", 4:"orange", 5:"green", 6:"blue", 7:"violet"]
    private let variantIndex: [ButtonVariant: UInt8] = [.default:0, .outline:1, .secondary:2, .ghost:3, .destructive:4, .link:5]
    private let variantFromIndex: [UInt8: ButtonVariant] = [0:.default, 1:.outline, 2:.secondary, 3:.ghost, 4:.destructive, 5:.link]

    func encodePreset() -> String {
        var bytes = [UInt8]()
        bytes.append(1) // version
        let ti = themeIndex[selectedTheme] ?? 0
        let vi = variantIndex[customVariant] ?? 0
        bytes.append(ti << 5 | vi << 2 | (isFullWidth ? 2 : 0) | (cardShowCustomBorder ? 1 : 0))
        bytes.append(UInt8(Int(cornerRadius)))
        bytes.append(UInt8(Int(shadowRadius)))
        bytes.append(UInt8(Int(cardCorner)))
        bytes.append(UInt8(Int(cardBorderWidth * 2)))
        return Data(bytes).base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }

    func applyPreset(_ code: String) {
        var s = code
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        while s.count % 4 != 0 { s += "=" }
        guard let data = Data(base64Encoded: s), data.count >= 6 else { return }

        let bytes = [UInt8](data)
        guard bytes[0] == 1 else { return } // version check

        let b1 = bytes[1]
        selectedTheme = themeFromIndex[b1 >> 5] ?? "zinc"
        customVariant = variantFromIndex[(b1 >> 2) & 0x07] ?? .default
        isFullWidth = (b1 & 2) != 0
        cardShowCustomBorder = (b1 & 1) != 0

        cornerRadius = Double(bytes[2])
        shadowRadius = Double(bytes[3])
        cardCorner = Double(bytes[4])
        cardBorderWidth = Double(bytes[5]) / 2.0

        presetInput = ""
    }
}

// MARK: - Input Demo (needs @State)

private struct InputStateDemo: View {
    @State private var text = ""
    var body: some View {
        Input("Type something…", text: $text)
    }
}

// MARK: - Glass TextField Style

struct GlassTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(.secondary.opacity(0.2), lineWidth: 0.5)
            )
    }
}

#Preview {
    ContentView()
}
