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
