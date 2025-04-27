import AudioKit
import AudioKitEX
import SoundpipeAudioKit
import AVFoundation
import Foundation
import SwiftUI

struct KickParams {
    var pitch: AUValue = 50.0
    var pitchDrop: AUValue = 80.0
    var decay: AUValue = 0.3
    var tone: AUValue = 0.8
    var drive: AUValue = 0.5
}

class KickEngine: ObservableObject {
    private let engine = AudioEngine()

    private var osc: Oscillator!
    private var ampEnv: AmplitudeEnvelope!

    private var click: WhiteNoise!
    private var clickEnv: AmplitudeEnvelope!

    private var filter: LowPassFilter!
    private var bodyDist: TanhDistortion!
    private var mix: Mixer!
    private var isGateOpen = false

    @Published var params = KickParams()

    init() {
        setupAudioSession()
        configureAudioChain()
    }

    private func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
        } catch {
            print("❌ AVAudioSession Error: \(error.localizedDescription)")
        }
    }

    private func configureAudioChain() {
        // Body oscillator
        osc = Oscillator(waveform: Table(.sine))
        osc.amplitude = 1.0
        osc.frequency = params.pitch

        ampEnv = AmplitudeEnvelope(osc)
        ampEnv.attackDuration = 0.0
        ampEnv.decayDuration = params.decay
        ampEnv.sustainLevel = 0.0
        ampEnv.releaseDuration = 0.015

        // Click
        click = WhiteNoise(amplitude: 0.4)
        clickEnv = AmplitudeEnvelope(click)
        clickEnv.attackDuration = 0.0
        clickEnv.decayDuration = 0.01
        clickEnv.sustainLevel = 0.0
        clickEnv.releaseDuration = 0.001

        // Click goes raw to output
        // Body → filter → distortion
        filter = LowPassFilter(ampEnv)
        bodyDist = TanhDistortion(filter)

        // Mix both
        mix = Mixer(clickEnv, bodyDist)
        engine.output = mix

        do {
            try engine.start()
            print("✅ AudioKit engine started.")
        } catch {
            print("❌ AudioKit failed to start: \(error.localizedDescription)")
        }
    }

    func triggerKick() {
        // Final pitch params
        osc.amplitude = 1.0
        ampEnv.decayDuration = params.decay
        filter.cutoffFrequency = 500 + pow(params.tone, 2) * 4000
        bodyDist.pregain = 20 + params.drive * 60

        // Envelope retrigger logic
        if isGateOpen {
            osc.stop()
            click.stop()
            ampEnv.closeGate()
            clickEnv.closeGate()
            isGateOpen = false

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.triggerKick()
            }
            return
        }

        // Start sound
        osc.frequency = params.pitchDrop
        osc.start()
        click.start()
        ampEnv.openGate()
        clickEnv.openGate()
        isGateOpen = true

        // Pitch drop glide
        let steps = 20
        let totalTime = Double(params.decay)
        let pitchDiff = params.pitchDrop - params.pitch

        for i in 0..<steps {
            let t = Double(i) * totalTime / Double(steps)
            let value = params.pitchDrop - (pitchDiff * AUValue(i) / AUValue(steps))
            DispatchQueue.main.asyncAfter(deadline: .now() + t) {
                self.osc.frequency = value
            }
        }
    }

    func stop() {
        engine.stop()
    }
}

