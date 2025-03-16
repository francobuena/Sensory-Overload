import SwiftUI
import CoreMotion

class MagnetManager: ObservableObject {
    private let motionManager = CMMotionManager()
    @Published var magneticField = CMMagneticField(x: 0, y: 0, z: 0)
    
    func startMagnetometerUpdates() {
        // Initial magnetometer check
        if motionManager.isMagnetometerAvailable {
            motionManager.magnetometerUpdateInterval = 0.1 // Update every 0.1 seconds
            motionManager.startMagnetometerUpdates(to: .main) { (data, error) in
                if let magnetometerData = data {
                    self.magneticField = magnetometerData.magneticField
                }
            }
        } else {
            print("Magnetometer is not available on this device.")
        }
    }

    func stopMagnetometerUpdates() {
        if motionManager.isMagnetometerActive {
            motionManager.stopMagnetometerUpdates()
        }
    }
}

struct MagnetometerView: View {
    @StateObject private var magnetManager = MagnetManager()

    var body: some View {
        VStack {
            Text("Magnetometer Data")
                .font(.title)
                .padding()

            Text("X: \(magnetManager.magneticField.x, specifier: "%.2f") µT")
            Text("Y: \(magnetManager.magneticField.y, specifier: "%.2f") µT")
            Text("Z: \(magnetManager.magneticField.z, specifier: "%.2f") µT")
        }
        .padding()
        .onAppear {
            magnetManager.startMagnetometerUpdates()
        }
        .onDisappear {
            magnetManager.stopMagnetometerUpdates()
        }
    }
}
