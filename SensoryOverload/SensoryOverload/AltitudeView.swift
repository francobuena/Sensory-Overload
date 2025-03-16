import SwiftUI
import CoreLocation

class AltitudeManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var altitude: String = "0 meters"
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Pass the last known altitude collected
        if let altitude = locations.last?.altitude {
            self.altitude = String(format: "%.2f meters", altitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Error handling
        print("Failed to get altitude: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Determine permission levels
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            print("IS AUTHORIZED")
        default:
            print("IS NOT AUTHORIZED")
            locationManager.stopUpdatingLocation()
        }
    }
}

struct AltitudeView: View {
    @StateObject private var altitudeManager = AltitudeManager()
    
    var body: some View {
        VStack {
            Text("Current Elevation")
                .font(.largeTitle)
                .padding()
            
            Text(altitudeManager.altitude)
                .font(.system(size: 40, weight: .bold, design: .monospaced))
                .padding()
            
            Text("Move to see elevation changes!")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
    }
}
