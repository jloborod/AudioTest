import SwiftUI
import AudioKit
import AudioKitEX
import SoundpipeAudioKit

class ToneEngine: ObservableObject {
    let engine = AudioEngine()
    let fmOsc = FMOscillator()

    init() {
        fmOsc.amplitude = 0.4
        engine.output = fmOsc

        do {
            try engine.start()
            fmOsc.start()
        } catch {
            print("AudioKit failed to start: \(error.localizedDescription)")
        }
    }

    func setFMFrequency(_ freq: AUValue) {
        fmOsc.baseFrequency = freq
    }
}

struct ContentView: View {
    @StateObject var engine = ToneEngine()
    @State private var freq: AUValue = 440

    var freqBinding: Binding<Double> {
        Binding<Double>(
            get: { Double(freq) },
            set: { freq = AUValue($0) }
        )
    }
    var body: some View {
        ZStack {
            Color.theme.bgPrimary.ignoresSafeArea()

            VStack(spacing: 30) {
                Text("Mechanical Child")
                    .font(.title)
                    .foregroundColor(.theme.textPrimary)

                Fader(value: freqBinding, range: 100...1000, step: 1, label: "Freq")

                Knob(
                    value: Binding(
                        get: { Double((freq - 100) / 900) },
                        set: { freq = AUValue($0 * 900 + 100) }
                    ),
                    label: "Freq",
                    size: 100,
                    displayValue: "\(Int(freq)) Hz"
                )
                .frame(maxWidth: .infinity)

                Text("\(Int(freq)) Hz")
                    .font(.headline)
                    .foregroundColor(.theme.textSecondary)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
