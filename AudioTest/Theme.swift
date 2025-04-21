import SwiftUI

// MARK: - Color from HEX Support

extension Color {
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

    static let theme = Theme()
}

// MARK: - Theme Definition

struct Theme {
    
    // MARK: Backgrounds
    let bgPrimary        = Color(hex: "#121212")
    let bgSecondary      = Color(hex: "#1e1e1e")
    let bgTertiary       = Color(hex: "#2c2c2c")
    let bgElevated       = Color(hex: "#181818")
    let bgContrast       = Color(hex: "#232323")

    // MARK: Text
    let textPrimary      = Color(hex: "#fafafa")
    let textSecondary    = Color(hex: "#a0a0a0")
    let textInverted     = Color.black

    // MARK: Borders & Lines
    let borderLight      = Color(hex: "#2a2a2a")
    let borderDark       = Color(hex: "#141414")
    let borderAccent     = Color(hex: "#006dff")

    // MARK: Accent / Highlights
    let accentPrimary    = Color(hex: "#ffa63b") // warm orange
    let accentSecondary  = Color(hex: "#00d6ff") // cyan

    // MARK: Status / Feedback
    let statusError      = Color(hex: "#ff4d4d")
    let statusWarning    = Color(hex: "#ffae42")
    let statusSuccess    = Color(hex: "#4caf50")
}
