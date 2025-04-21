import SwiftUI

struct Fader: View {
    @Binding var value: Double
    var range: ClosedRange<Double> = 0...1
    var step: Double = 0.01
    var label: String? = nil

    var body: some View {
        VStack(spacing: 8) {
            if let label = label {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.theme.textSecondary)
            }

            Slider(value: $value, in: range, step: step)
                .tint(.theme.accentPrimary) // Track + Thumb color
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                .frame(height: 36)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.theme.bgSecondary)
                )
        }
        .frame(maxWidth: .infinity)
    }
}
