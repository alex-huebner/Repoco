//
//  MyDevicesView.swift
//  Repoco
//
//  Created by Alexander Huebner on 19.11.22.
//

import SwiftUI

struct MyDevicesView: View {
    @EnvironmentObject var measurements: MeasurementList
    var body: some View {
        ZStack {
            Color(UIColor.systemGray6)
            VStack {
                Spacer().frame(height: 160)
                DeviceBarChart()
                List {
                    ForEach(measurements.measurements, id: \.id) { measurement in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(measurement.name)
                                Text(measurement.deviceType.rawValue).font(.subheadline).foregroundColor(.gray)
                            }
                            Spacer()
                            Text("3.9 Wh")
                        }
                    }
                }
            }
        }.ignoresSafeArea()
    }
}

struct MyDevicesView_Previews: PreviewProvider {
    @StateObject static var measurements: MeasurementList = MeasurementList(measurements: [
        Measurement(deviceType: DeviceType.tv, name: "LG TV 5060", consumption: 44.9),
        Measurement(deviceType: DeviceType.oven, name: "Super Washy", consumption: 77),
        Measurement(deviceType: DeviceType.hairdryer, name: "Foenohara", consumption: 12)
    ])
    static var previews: some View {
        MyDevicesView().environmentObject(measurements)
    }
}
