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
        NavigationView {
            if measurements.measurements.count > 0 {
                List {
                    ForEach(measurements.measurements, id: \.id) { measurement in
                        HistoryButtonView(
                            name: dateToString(measurement.date),
                            subtitle: measurement.deviceType.rawValue,
                            image: measurement.deviceType.description,
                            measurement: measurement
                        )
                    }
                }
                .navigationTitle("History")
            } else {
                ZStack {
                    Color(UIColor.systemGray6)
                    Text("No measurements yet")
                        .navigationTitle("History")
                        .foregroundColor(Color.gray)
                }
                .ignoresSafeArea()
            }
        }
    }
}

extension MyDevicesView {
    func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: date)
    }
}

//struct MyDevicesView_Previews: PreviewProvider {
//    @StateObject static var measurements: MeasurementList = MeasurementList(measurements: [
//        Measurement(deviceType: DeviceType.tv, date: .now, consumption: 44.9),
//        Measurement(deviceType: DeviceType.oven, date: .now, consumption: 77),
//        Measurement(deviceType: DeviceType.hairdryer, date: .now, consumption: 12)
//    ])
//    static var previews: some View {
//        MyDevicesView().environmentObject(measurements)
//    }
//}
