//
//  ContentView.swift
//  lab4
//
//  Created by f1211043 on 28/9/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
                    BeaconView().tabItem {
                        Image(systemName: "waveform.circle.fill")
                        Text("iBeacons")
                    }
            
                    BleView().tabItem {
                        Image(systemName: "waveform.circle.fill")
                        Text("BLE")
                    }
                }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
