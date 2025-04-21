import SwiftUI

@main
struct AudioTestApp: App {
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color.theme.bgPrimary
                    .ignoresSafeArea() // Full-screen theme background
                ContentView()
                .environment(\.theme, AppTheme())
            }
            .preferredColorScheme(.dark) // Optional, but great for consistency
        }
    }
}
