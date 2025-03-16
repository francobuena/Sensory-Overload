import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView {
                AltitudeView()
                    .tabItem {
                        Label("Altimeter", systemImage: "figure.run")
                    }
                MagnetometerView()
                    .tabItem {
                        Label("Magnets", systemImage: "bolt.horizontal")
                    }
                MotionView()
                    .tabItem {
                        Label("Motion", systemImage: "rotate.right")
                    }
            }
        }
    }
}
