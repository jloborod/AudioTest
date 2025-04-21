import SwiftUI

struct Fader: View {
    @Binding var value: Double
    var range: ClosedRange<Double> = 0...1
    var step: Double = 0.01
    var label: String? = nil
    var isVertical: Bool = false

    var body: some View {
        VStack(spacing: 8) {
            if let label = label {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.theme.textSecondary)
            }

            GeometryReader { geo in
                ZStack(alignment: .topLeading) {
                    let trackLength = isVertical ? geo.size.height : geo.size.width
                    let trackThickness: CGFloat = 6
                    let thumbSize = CGSize(width: isVertical ? 26 : 14, height: isVertical ? 14 : 26)

                    // Track background
                    RoundedRectangle(cornerRadius: trackThickness / 2)
                        .fill(Color.theme.bgSecondary)
                        .frame(
                            width: isVertical ? trackThickness : trackLength,
                            height: isVertical ? trackLength : trackThickness
                        )
                        .position(x: isVertical ? geo.size.width / 2 : trackLength / 2,
                                  y: isVertical ? trackLength / 2 : geo.size.height / 2)

                    // Filled track
                    RoundedRectangle(cornerRadius: trackThickness / 2)
                        .fill(Color.theme.accentPrimary)
                        .frame(
                            width: isVertical ? trackThickness : thumbOffset(in: trackLength),
                            height: isVertical ? thumbOffset(in: trackLength) : trackThickness
                        )
                        .position(x: isVertical ? geo.size.width / 2 : thumbOffset(in: trackLength) / 2,
                                  y: isVertical ? trackLength - thumbOffset(in: trackLength) / 2 : geo.size.height / 2)

                    // Thumb (static, no animation)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.theme.accentPrimary)
                        .frame(width: thumbSize.width, height: thumbSize.height)
                        .position(
                            x: isVertical ? geo.size.width / 2 : thumbOffset(in: trackLength),
                            y: isVertical ? trackLength - thumbOffset(in: trackLength) : geo.size.height / 2
                        )
                }
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { gesture in
                            let location = isVertical ? gesture.location.y : gesture.location.x
                            let trackLength = isVertical ? geo.size.height : geo.size.width
                            let relative = location / trackLength
                            let clamped = min(max(0, relative), 1)
                            let newValue = clamped * (range.upperBound - range.lowerBound) + range.lowerBound
                            value = (newValue / step).rounded() * step
                        }
                )
            }
        }
    }

    private func thumbOffset(in trackLength: CGFloat) -> CGFloat {
        let progress = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return CGFloat(progress) * trackLength
    }
}
