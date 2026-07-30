import SwiftUI
import ShadcnSwiftUI
import Charts

// MARK: - Data Models

struct Customer: Identifiable {
    var id = UUID()
    var name: String; var email: String; var amount: Double; var status: Status; var tags: [String]
    enum Status: String, CaseIterable { case lead, active, churned }
    var initials: String { name.split(separator: " ").prefix(2).compactMap { $0.first }.map(String.init).joined() }
}

struct MonthlySales: Identifiable { var id = UUID(); var month: String; var revenue: Double; var cost: Double }

enum CRMTab: String, CaseIterable { case dashboard, customers, analytics, settings }

struct AppData {
    static let customers: [Customer] = [
        Customer(name: "Olivia Martin", email: "olivia@acme.com", amount: 1999, status: .active, tags: ["VIP"]),
        Customer(name: "Jackson Lee", email: "jackson@acme.com", amount: 39, status: .lead, tags: ["New"]),
        Customer(name: "Isabella Nguyen", email: "isabella@acme.com", amount: 299, status: .active, tags: ["New"]),
        Customer(name: "William Kim", email: "william@acme.com", amount: 99, status: .churned, tags: []),
        Customer(name: "Sofia Davis", email: "sofia@acme.com", amount: 599, status: .active, tags: ["VIP"]),
        Customer(name: "Ethan Chen", email: "ethan@acme.com", amount: 1299, status: .active, tags: ["Enterprise"]),
    ]
    static let monthlySales: [MonthlySales] = [
        MonthlySales(month: "Jan", revenue: 4200, cost: 2100), MonthlySales(month: "Feb", revenue: 3800, cost: 1900),
        MonthlySales(month: "Mar", revenue: 5100, cost: 2400), MonthlySales(month: "Apr", revenue: 4600, cost: 2200),
        MonthlySales(month: "May", revenue: 5900, cost: 2800), MonthlySales(month: "Jun", revenue: 6500, cost: 3100),
    ]
    static let analytics: [MonthlySales] = [
        MonthlySales(month: "Jan", revenue: 2800, cost: 1400), MonthlySales(month: "Feb", revenue: 3200, cost: 1500),
        MonthlySales(month: "Mar", revenue: 2900, cost: 1300), MonthlySales(month: "Apr", revenue: 4100, cost: 1900),
        MonthlySales(month: "May", revenue: 3800, cost: 1700), MonthlySales(month: "Jun", revenue: 4900, cost: 2300),
    ]
}

// MARK: - CRM Root View

struct CRMContentView: View {
    @StateObject private var sidebar = SidebarState(isOpen: true)
    @State private var activeTab: CRMTab = .dashboard

    var body: some View {
        SidebarProvider(state: sidebar) {
            HStack(spacing: 0) {
                Sidebar {
                    SidebarHeader {
                        HStack(spacing: 10) {
                            Image(systemName: "building.2.fill").font(.title2).foregroundStyle(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                            if sidebar.isOpen && !sidebar.isCollapsed { Text("Acme CRM").font(.headline) }
                            Spacer()
                        }
                    }
                    SidebarContent {
                        SidebarGroup(label: "Main") {
                            SidebarMenuItem(icon: "chart.bar.fill", "Dashboard", isActive: activeTab == .dashboard) { activeTab = .dashboard }
                            SidebarMenuItem(icon: "person.2.fill", "Customers", isActive: activeTab == .customers) { activeTab = .customers }
                            SidebarMenuItem(icon: "chart.pie.fill", "Analytics", isActive: activeTab == .analytics) { activeTab = .analytics }
                            SidebarMenuItem(icon: "gearshape.fill", "Settings", isActive: activeTab == .settings) { activeTab = .settings }
                        }
                    }
                    SidebarFooter { SidebarTrigger() }
                }
                mainArea
            }
        }
    }

    @ViewBuilder private var mainArea: some View {
        VStack(spacing: 0) {
            topBar; Divider()
            ScrollView(.vertical) { contentPage.padding(24).frame(maxWidth: 1024, alignment: .leading) }.frame(maxWidth: .infinity, alignment: .center)
        }
    }

    private var topBar: some View {
        HStack {
            if !sidebar.isOpen { SidebarTrigger().padding(.leading, 12) }
            Spacer()
            Button("Log out") { ToastHost.shared.info("Logged out") }.shadcnButton(variant: .ghost, size: .sm)
        }.padding(.vertical, 8).padding(.horizontal, 16)
    }

    @ViewBuilder private var contentPage: some View {
        switch activeTab {
        case .dashboard: DashboardView()
        case .customers: CustomerListView()
        case .analytics: AnalyticsView()
        case .settings: SettingsView()
        }
    }
}

// MARK: - Dashboard

struct DashboardView: View {
    @Environment(\.shadcnToken) private var token
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Dashboard").font(.title.bold())
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                statCard(title: "Revenue", value: "$30,200", trend: "+12.5%", icon: "dollarsign.circle.fill", color: .green)
                statCard(title: "Customers", value: "1,234", trend: "+8.2%", icon: "person.circle.fill", color: .blue)
                statCard(title: "Conversion", value: "24.5%", trend: "+3.1%", icon: "arrow.up.right.circle.fill", color: .purple)
                statCard(title: "Churn", value: "2.4%", trend: "-0.8%", icon: "arrow.down.circle.fill", color: .orange)
            }
            ChartContainer(config: ChartConfig(colors: ["revenue": .green, "cost": .red], labels: ["revenue": "Revenue", "cost": "Cost"])) {
                Chart(AppData.monthlySales) { item in
                    BarMark(x: .value("Month", item.month), y: .value("Revenue", item.revenue)).foregroundStyle(by: .value("Kind", "revenue"))
                    BarMark(x: .value("Month", item.month), y: .value("Cost", item.cost)).foregroundStyle(by: .value("Kind", "cost"))
                }
            }
            Text("Recent customers").font(.title3.bold())
            ForEach(AppData.customers) { c in
                HStack {
                    avatar(c.initials)
                    VStack(alignment: .leading) { Text(c.name).font(.system(size: 14, weight: .medium)); Text(c.email).font(.system(size: 12)).foregroundColor(token.mutedForeground) }
                    Spacer()
                    statusBadge(c.status)
                }.padding(.vertical, 4)
            }
        }
    }
    private func statCard(title: String, value: String, trend: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack { Image(systemName: icon).font(.title3).foregroundColor(color); Spacer(); Text(trend).font(.system(size: 12, weight: .medium)).foregroundColor(trend.hasPrefix("+") ? .green : .red) }
            Text(value).font(.title2.bold()); Text(title).font(.system(size: 13)).foregroundColor(token.mutedForeground)
        }.padding(16).background(token.card).clipShape(RoundedRectangle(cornerRadius: token.radius)).overlay(RoundedRectangle(cornerRadius: token.radius).strokeBorder(token.border, lineWidth: 1))
    }
}

// MARK: - Customers

struct CustomerListView: View {
    @Environment(\.shadcnToken) private var token
    @State private var search = ""
    @State private var statusFilter = "All"
    @State private var customers = AppData.customers
    @State private var showDelete: Customer? = nil

    var filtered: [Customer] {
        customers.filter {
            (search.isEmpty || $0.name.localizedCaseInsensitiveContains(search) || $0.email.localizedCaseInsensitiveContains(search))
                && (statusFilter == "All" || $0.status.rawValue == statusFilter.lowercased())
        }
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack { Text("Customers").font(.title.bold()); Spacer(); Button("Add") { addCustomer() }.shadcnButton(variant: .default, size: .sm) }
            HStack(spacing: 12) {
                TextField("Search…", text: $search).textFieldStyle(.roundedBorder).frame(width: 200)
                Spacer()
                Select(placeholder: "Status", selection: $statusFilter) {
                    SelectItem("All", value: "All")
                    SelectItem("Active", value: "active"); SelectItem("Lead", value: "lead"); SelectItem("Churned", value: "churned")
                }.frame(width: 160)
            }
            VStack(spacing: 0) {
                HStack { Text("Name").frame(maxWidth: .infinity, alignment: .leading); Text("Status").frame(width: 70, alignment: .leading); Text("Amount").frame(width: 70, alignment: .trailing); Text("").frame(width: 30) }.font(.system(size: 12, weight: .semibold)).foregroundColor(token.mutedForeground).padding(.horizontal, 12).padding(.vertical, 8)
                Divider()
                if filtered.isEmpty { Text("No customers found").font(.system(size: 14)).foregroundColor(token.mutedForeground).padding(20) }
                ForEach(filtered) { c in
                    VStack(spacing: 0) {
                        HStack {
                            HStack(spacing: 8) { avatar(c.initials); VStack(alignment: .leading) { Text(c.name).font(.system(size: 14, weight: .medium)); Text(c.email).font(.system(size: 12)).foregroundColor(token.mutedForeground) } }.frame(maxWidth: .infinity, alignment: .leading)
                            statusBadge(c.status).frame(width: 70, alignment: .leading)
                            Text("$\(String(format: "%.0f", c.amount))").font(.system(size: 14)).frame(width: 70, alignment: .trailing)
                            Button { showDelete = c } label: { Image(systemName: "trash").font(.system(size: 12)).foregroundColor(token.mutedForeground) }.buttonStyle(.borderless)
                        }.padding(.horizontal, 12).padding(.vertical, 8)
                        Divider()
                    }
                }
            }.background(token.card).clipShape(RoundedRectangle(cornerRadius: token.radius)).overlay(RoundedRectangle(cornerRadius: token.radius).strokeBorder(token.border, lineWidth: 1))
        }
        .popover(isPresented: Binding(get: { showDelete != nil }, set: { if !$0 { showDelete = nil } })) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Delete \(showDelete?.name ?? "")?").font(.system(size: 14, weight: .medium))
                Text("This action cannot be undone.").font(.system(size: 13)).foregroundColor(token.mutedForeground)
                HStack { Spacer(); Button("Cancel") { showDelete = nil }.shadcnButton(variant: .outline, size: .sm); Button("Delete") { if let c = showDelete { customers.removeAll { $0.id == c.id }; ToastHost.shared.error("\(c.name) deleted") }; showDelete = nil }.shadcnButton(variant: .destructive, size: .sm) }
            }.padding(16)
        }
    }
    private func addCustomer() {
        customers.append(Customer(name: "New Lead", email: "new@acme.com", amount: 0, status: .lead, tags: []))
        ToastHost.shared.success("Customer added")
    }
}

// MARK: - Analytics

struct AnalyticsView: View {
    @Environment(\.shadcnToken) private var token
    @State private var progress: Double = 68
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Analytics").font(.title.bold())
            ChartContainer(config: ChartConfig(colors: ["revenue": .blue], labels: ["revenue": "Revenue"])) {
                Chart(AppData.analytics) { item in
                    LineMark(x: .value("Month", item.month), y: .value("Revenue", item.revenue)).foregroundStyle(by: .value("Kind", "revenue")).symbol(.circle)
                    AreaMark(x: .value("Month", item.month), y: .value("Revenue", item.revenue)).foregroundStyle(by: .value("Kind", "revenue")).opacity(0.15)
                }
            }
            HStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 12) { Text("Revenue Goal").font(.headline); ProgressView(value: progress, total: 100).tint(.green); Text("\(String(format: "%.0f", progress))% of $100k").font(.system(size: 13)).foregroundColor(token.mutedForeground) }.padding(16).background(token.card).clipShape(RoundedRectangle(cornerRadius: token.radius)).overlay(RoundedRectangle(cornerRadius: token.radius).strokeBorder(token.border, lineWidth: 1))
                VStack(alignment: .leading, spacing: 12) { Text("Adjust goal").font(.headline); Slider(value: $progress, in: 0...100, step: 1).tint(.green) }.padding(16).background(token.card).clipShape(RoundedRectangle(cornerRadius: token.radius)).overlay(RoundedRectangle(cornerRadius: token.radius).strokeBorder(token.border, lineWidth: 1))
            }
        }
    }
}

// MARK: - Settings

struct SettingsView: View {
    @Environment(\.shadcnToken) private var token
    @State private var name = "Admin"; @State private var email = "admin@acme.com"; @State private var enable2FA = true; @State private var otp = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Settings").font(.title.bold())
            VStack(spacing: 16) {
                FormField("Name") { TextField("Name", text: $name).textFieldStyle(.roundedBorder) }
                FormField("Email") { TextField("Email", text: $email).textFieldStyle(.roundedBorder) }.formDescription("Used for login and notifications.")
                FormField("Bio") { TextEditor(text: .constant("CRM admin")).frame(height: 60).overlay(RoundedRectangle(cornerRadius: 6).strokeBorder(token.input, lineWidth: 1)) }
            }.padding(20).background(token.card).clipShape(RoundedRectangle(cornerRadius: token.radius)).overlay(RoundedRectangle(cornerRadius: token.radius).strokeBorder(token.border, lineWidth: 1))
            VStack(alignment: .leading, spacing: 16) {
                Toggle("Enable Two-Factor Auth", isOn: $enable2FA).font(.headline)
                if enable2FA { Text("Enter the 6-digit code from your authenticator app").font(.system(size: 13)).foregroundColor(token.mutedForeground); InputOTP(code: $otp, length: 6) }
            }.padding(20).background(token.card).clipShape(RoundedRectangle(cornerRadius: token.radius)).overlay(RoundedRectangle(cornerRadius: token.radius).strokeBorder(token.border, lineWidth: 1))
            Button("Save Changes") { ToastHost.shared.success("Settings saved") }.shadcnButton(variant: .default, size: .sm)
        }
    }
}

// MARK: - Helpers

private func avatar(_ initials: String, size: CGFloat = 28) -> some View {
    Text(initials).font(.system(size: size * 0.4, weight: .medium)).foregroundColor(.white)
        .frame(width: size, height: size).background(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)).clipShape(Circle())
}

private func statusBadge(_ s: Customer.Status) -> some View {
    let (bg, fg): (Color, Color) = {
        switch s { case .active: (Color.green.opacity(0.15), Color.green); case .lead: (Color.yellow.opacity(0.2), Color.yellow); case .churned: (Color.gray.opacity(0.15), Color.gray) }
    }()
    return Text(s.rawValue.capitalized).font(.system(size: 11, weight: .medium)).foregroundColor(fg).padding(.horizontal, 6).padding(.vertical, 2).background(bg).clipShape(RoundedRectangle(cornerRadius: 4))
}
