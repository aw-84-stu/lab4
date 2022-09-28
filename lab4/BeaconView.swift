//
//  BeaconView.swift
//  lab4
//
//  Created by f1211043 on 28/9/2022.
//

import SwiftUI
import CoreLocation

struct BeaconView: View {
        @ObservedObject var detector = BeaconDetector()
        @State private var isScanning: Bool = false
        
        var body: some View {
            List {
                Section(header: Text("Monitoring")) {
                    Text(detector.status)
                }
                Section(header: Text("Ranging")) {
                    ForEach(detector.rangedBeacons) { beacon in
                        HStack{
                            Text("Major: \(beacon.major)")
                            Spacer()
                            Text("Minor: \(beacon.minor)")
                            Spacer()
                            //Text("Proximity: \(beacon.proximity.rawValue)")
                            Text(beacon.proximity.stringValue)
                        }
                    }
                }
                Section(header: Text("Control")) {
                    Toggle("Scan", isOn: $isScanning)
                        .onChange(of: isScanning) { value in
                            if value == true {
                                detector.startScanning()
                            } else {
                                detector.stopScanning()
                            }
                        }
                        .padding()
                }
            }
        }
}

struct BeaconView_Previews: PreviewProvider {
    static var previews: some View {
        BeaconView()
    }
}

class BeaconDetector: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    var locationManager = CLLocationManager()
    
    
    let uuid = UUID(uuidString: "12345678-1234-1234-1234-123456789ABC")

    var beaconRegion: CLBeaconRegion?
    @Published var status = "Inited"

    var constraint: CLBeaconIdentityConstraint?
    @Published var rangedBeacons: [CLBeacon] = []
    
    override init() {
        super.init()
            
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            
            beaconRegion = CLBeaconRegion(uuid: uuid!, identifier: "M5StickC beacons");
        
        constraint = CLBeaconIdentityConstraint(uuid: uuid!)
    }
    
    func startScanning() {
        locationManager.startMonitoring(for: beaconRegion!)
        status = "Scanning started"
    }

    func stopScanning() {
        locationManager.stopMonitoring(for: beaconRegion!)
        status = "Scanning stopped"
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        status = "Entered \(region.identifier) region."
        
        locationManager.startRangingBeacons(satisfying: constraint!)
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        status = "Left \(region.identifier) region."
        
        
        locationManager.stopRangingBeacons(satisfying: constraint!)
        rangedBeacons = []
    }

    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        
        rangedBeacons = beacons
    }
    
}

extension CLBeacon: Identifiable {}

extension CLProximity {
    
    var stringValue: String {
        switch self {
        case .unknown:
            return "unknown"
        case .immediate:
            return "immediate"
        case .near:
            return "near"
        case .far:
            return "far"
        @unknown default:
            return "unknown"
        }
    }
}
