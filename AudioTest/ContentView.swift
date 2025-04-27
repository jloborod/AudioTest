import SwiftUI

struct ContentView: View {
    @StateObject var kickEngine = KickEngine()

    var body: some View {
        KickEngineView(engine: kickEngine)
    }
}

#Preview {
    KickEngineView(engine: KickEngine())
}
