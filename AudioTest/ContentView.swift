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
        } catch {
            print("AudioKit failed to start: \(error.localizedDescription)")
        }
    }

    func start() {
        fmOsc.start()
    }

    func stop() {
        fmOsc.stop()
    }

    func setFMFrequency(_ freq: AUValue) {
        fmOsc.baseFrequency = freq
    }
}

struct ContentView: View {
    @StateObject var engine = ToneEngine()
    @State private var freq: AUValue = 440
    @State private var isPlaying = false

    var freqBinding: Binding<Double> {
        Binding<Double>(
            get: { Double(freq) },
            set: {
                freq = AUValue($0)
                engine.setFMFrequency(freq)
            }
        )
    }

    var body: some View {
        ZStack {
            Color.theme.bgPrimary.ignoresSafeArea()

            VStack(spacing: 30) {
                Text("Mechanical Child")
                    .font(.title)
                    .foregroundColor(.theme.textPrimary)

                // Play / Stop button
                Button(action: {
                    isPlaying.toggle()
                    isPlaying ? engine.start() : engine.stop()
                }) {
                    Text(isPlaying ? "Stop" : "Play")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 120)
                        .background(isPlaying ? Color.red : Color.green)
                        .cornerRadius(12)
                }

                // Fader
                Fader(value: freqBinding, range: 100...1000, step: 1, label: "Freq")
                    .frame(width: 250, height: 40)

                // Knob
                Knob(
                    value: Binding(
                        get: { Double((freq - 100) / 900) },
                        set: { freq = AUValue($0 * 900 + 100); engine.setFMFrequency(freq) }
                    ),
                    label: "Freq",
                    size: 100,
                    displayValue: "\(Int(freq)) Hz"
                )
                .frame(maxWidth: .infinity)

                // Frequency text
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
