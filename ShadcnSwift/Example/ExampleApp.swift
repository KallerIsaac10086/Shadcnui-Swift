import SwiftUI
import ShadcnSwiftUI

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ZStack {
                CRMContentView()
                Toaster()
            }
            .frame(minWidth: 960, minHeight: 600)
        }
    }
}
