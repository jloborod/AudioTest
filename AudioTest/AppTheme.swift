import SwiftUI

// MARK: - Color from HEX Support

public extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)

        // Remove `#` prefix if present
        if hex.hasPrefix("#") {
            scanner.currentIndex = hex.index(after: hex.startIndex)
        }

        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = Double((rgbValue >> 16) & 0xFF) / 255
        let g = Double((rgbValue >> 8) & 0xFF) / 255
        let b = Double(rgbValue & 0xFF) / 255

        self.init(red: r, green: g, blue: b)
    }

    static let theme = AppTheme()
}

// MARK: - Theme Definition

public struct AppTheme: Theme {
    
    // MARK: Backgrounds
    public let bgPrimary        = Color(hex: "#121212")
    public let bgSecondary      = Color(hex: "#1e1e1e")
    public let bgTertiary       = Color(hex: "#2c2c2c")
    public let bgElevated       = Color(hex: "#181818")
    public let bgContrast       = Color(hex: "#232323")

    // MARK: Text
    public let textPrimary      = Color(hex: "#fafafa")
    public let textSecondary    = Color(hex: "#a0a0a0")
    public let textInverted     = Color.black

    // MARK: Borders & Lines
    public let borderLight      = Color(hex: "#2a2a2a")
    public let borderDark       = Color(hex: "#141414")
    public let borderAccent     = Color(hex: "#006dff")

    // MARK: Accent / Highlights
    public let accentPrimary    = Color(hex: "#ffa63b") // warm orange
    public let accentSecondary  = Color(hex: "#00d6ff") // cyan

    // MARK: Status / Feedback
    public let statusError      = Color(hex: "#ff4d4d")
    public let statusWarning    = Color(hex: "#ffae42")
    public let statusSuccess    = Color(hex: "#4caf50")
}
