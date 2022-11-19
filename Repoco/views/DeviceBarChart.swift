//
//  DeviceBarChart.swift
//  Repoco
//
//  Created by Alexander Huebner on 19.11.22.
//

import SwiftUI
import Charts

struct DeviceBarChart: View {
    @EnvironmentObject var measurements: MeasurementList
    
    var body: some View {
        Chart {
            ForEach(measurements.measurements) {measurement in
                BarMark(
                    x: .value("Shape Type", measurement.date),
                    y: .value("Total Count", measurement.consumption)
                )
            }
        }
        .frame(width: 200, height: 200)
    }
}

//struct DeviceBarChart_Previews: PreviewProvider {
//    @StateObject static var measurements: MeasurementList = MeasurementList(measurements: [
//        Measurement(deviceType: DeviceType.tv, name: "LG TV 5060", consumption: 44.9),
//        Measurement(deviceType: DeviceType.oven, name: "Super Washy", consumption: 77),
//        Measurement(deviceType: DeviceType.hairdryer, name: "Foenohara", consumption: 12)
//    ])
//    static var previews: some View {
//        DeviceBarChart()
//            .environmentObject(measurements)
//    }
//}
