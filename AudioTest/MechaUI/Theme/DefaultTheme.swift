import SwiftUI

public struct DefaultTheme: Theme {
    public let bgPrimary = Color.black
    public let bgSecondary = Color.gray.opacity(0.2)
    public let textPrimary = Color.white
    public let textSecondary = Color.gray
    public let accentPrimary = Color.orange

    public init() {}
}
