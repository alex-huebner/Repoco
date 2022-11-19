//
//  ContentView.swift
//  Repoco
//
//  Created by Alexander Huebner on 18.11.22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var bleSession = BLESession()
    @StateObject var measurements: MeasurementList = MeasurementList(measurements: [])
    
    var body: some View {
        TabView {
            MeasureView()
                .tabItem() {
                    Label("Measure", systemImage: "lines.measurement.horizontal")
                }
            MyDevicesView()
                .tabItem() {
                    Label("History", systemImage: "book")
                }
        }
        .environmentObject(measurements)
        .environmentObject(bleSession)
        .onAppear(perform: fetchMeasurements)
    }
}

extension ContentView {
    func fetchMeasurements() -> Void {
        var measurementsEncoded = UserDefaults.standard.string(forKey: "measurements")?.data(using: .utf8)
        
        if (measurementsEncoded == nil) {
            measurements.measurements = []
            return
        }
        
        let decoder = JSONDecoder()
        if let measurementsDecoded = try? decoder.decode([Measurement].self, from: measurementsEncoded!) {
            measurements.measurements = measurementsDecoded
        } else {
            measurements.measurements = []
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
