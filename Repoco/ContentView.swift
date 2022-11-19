//
//  ContentView.swift
//  Repoco
//
//  Created by Alexander Huebner on 18.11.22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var measurements: MeasurementList = MeasurementList(measurements: [
        Measurement(deviceType: DeviceType.tv, date: .now, consumption: 44.9),
        Measurement(deviceType: DeviceType.oven, date: .now, consumption: 77),
        Measurement(deviceType: DeviceType.hairdryer, date: .now, consumption: 12)
    ])
    
    var body: some View {
        TabView {
            MeasureView()
                .tabItem() {
                    Label("Measure", systemImage: "lines.measurement.horizontal")
                }
            MyDevicesView()
                .tabItem() {
                    Label("My Devices", systemImage: "laptopcomputer.and.ipad")
                }
        }
        .background(.opacity(0))
        .environmentObject(measurements)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
