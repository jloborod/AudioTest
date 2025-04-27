import SwiftUI
import AVFoundation

struct KickEngineView: View {
    @ObservedObject var engine: KickEngine

    var body: some View {
        VStack(spacing: 20) {
            Text("Biome Kick Engine")
                .font(.headline)

            Button(action: {
                engine.triggerKick()
            }) {
                Text("💥 Trigger Kick")
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Group {
                Fader(value: Binding(
                    get: { Double(engine.params.pitch) },
                    set: { engine.params.pitch = AUValue($0) }),
                      range: 30...90, step: 1, label: "Final Pitch")

                Fader(value: Binding(
                    get: { Double(engine.params.pitchDrop) },
                    set: { engine.params.pitchDrop = AUValue($0) }),
                      range: 50...150, step: 1, label: "Pitch Drop")

                Fader(value: Binding(
                    get: { Double(engine.params.decay) },
                    set: { engine.params.decay = AUValue($0) }),
                      range: 0.1...1.0, step: 0.01, label: "Decay")

                Fader(value: Binding(
                    get: { Double(engine.params.tone) },
                    set: { engine.params.tone = AUValue($0) }),
                      range: 0.0...1.0, step: 0.01, label: "Tone")

                Fader(value: Binding(
                    get: { Double(engine.params.drive) },
                    set: { engine.params.drive = AUValue($0) }),
                      range: 0.0...1.0, step: 0.01, label: "Drive")
            }
        }
        .padding()
    }
}
