//
//  BeaconView.swift
//  lab4
//
//  Created by f1211043 on 28/9/2022.
//

import SwiftUI
import CoreLocation

struct BeaconView: View {
    var detector = BeaconDetector()
        @State private var isScanning: Bool = false
        
        var body: some View {
            List {
                Section(header: Text("Monitoring")) {
                    Text(detector.status)
                }
                Section(header: Text("Ranging")) {
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

class BeaconDetector {
    
    var locationManager = CLLocationManager()
    
    
    let uuid = UUID(uuidString: "12345678-1234-1234-1234-123456789ABC")

    var beaconRegion: CLBeaconRegion?
    var status = "Inited____"

    init() {
        locationManager.requestWhenInUseAuthorization()
        
        beaconRegion = CLBeaconRegion(uuid: uuid!, identifier: "M5StickC beacons")
    }
    
    func startScanning() {
        locationManager.startMonitoring(for: beaconRegion!)
        status = "Scanning started"
    }

    func stopScanning() {
        locationManager.stopMonitoring(for: beaconRegion!)
        status = "Scanning stopped"
    }
}
