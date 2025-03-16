import SwiftUI
import CoreMotion

class MotionManager: ObservableObject {
    private var motionManager = CMMotionManager()
    @Published var isMoving: Bool = false
    
    init() {
        startMotionDetection()
    }
    
    func startMotionDetection() {
        // Check if the device has an accelerometer
        guard motionManager.isAccelerometerAvailable else {
            print("Accelerometer not available")
            return
        }
        
        // Set the update interval (e.g., 0.1 seconds)
        motionManager.accelerometerUpdateInterval = 0.1
        
        // Start receiving accelerometer data
        motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
            guard let data = data else { return }
            
            // Check if the device is moving based on acceleration
            let isMoving = abs(data.acceleration.x) > 1.5 || abs(data.acceleration.y) > 1.5 || abs(data.acceleration.z) > 1.5
            
            // Update the state
            self.isMoving = isMoving
        }
    }
    
    deinit {
        motionManager.stopAccelerometerUpdates()
    }
}

struct MotionView: View {
    @StateObject private var motionManager = MotionManager()
    
    var body: some View {
        ZStack {
            // Change the background color based on motion
            motionManager.isMoving ? Color.green : Color.red
            Text(motionManager.isMoving ? "Green Light 🟢" : "Red Light 🛑")
                .font(.largeTitle)
                .foregroundColor(.white)
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .onAppear {
            motionManager.startMotionDetection()
        }
    }
}
