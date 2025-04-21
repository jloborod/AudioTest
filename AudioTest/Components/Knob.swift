import SwiftUI

struct Knob: View {
    @Binding var value: Double
    var label: String = ""
    var size: CGFloat = 80
    var displayValue: String? = nil

    @GestureState private var dragAmount: CGSize = .zero
    @State private var lastValue: Double = 0
    @State private var isFirstDrag = true

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.4), lineWidth: 2)
                    .frame(width: size, height: size)

                Circle()
                    .trim(from: 0.0, to: value)
                    .stroke(Color.theme.accentPrimary, lineWidth: 4)
                    .rotationEffect(.degrees(-90))
                    .frame(width: size, height: size)
            }

            Text(label)
                .font(.caption)
                .foregroundColor(.theme.textSecondary)

            Text(displayValue ?? String(format: "%.0f", value * 100))
                .font(.caption2)
                .foregroundColor(.theme.textPrimary)
        }
        .frame(width: size, height: size + 30)
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .updating($dragAmount) { value, state, _ in
                    state = value.translation
                }
                .onChanged { drag in
                    if isFirstDrag {
                        lastValue = value
                        isFirstDrag = false
                    }

                    let delta = -drag.translation.height
                    let scaledDelta = delta / 300.0
                    let newValue = min(max(lastValue + Double(scaledDelta), 0), 1)
                    value = newValue
                }
                .onEnded { _ in
                    lastValue = value
                    isFirstDrag = true
                }
        )
    }
}
