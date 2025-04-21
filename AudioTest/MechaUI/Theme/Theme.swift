import SwiftUI

public protocol Theme {
    var bgPrimary: Color { get }
    var bgSecondary: Color { get }
    var textPrimary: Color { get }
    var textSecondary: Color { get }
    var accentPrimary: Color { get }
}
