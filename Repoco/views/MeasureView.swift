//
//  MeasureView.swift
//  HackaTUM
//
//  Created by Ragnar Fischer on 19.11.22.
//

import SwiftUI

struct MeasureView: View {
    
    @EnvironmentObject private var bleSession: BLESession
    @EnvironmentObject private var measurements: MeasurementList
    
    var body: some View {
        NavigationView {
            if bleSession.peripheralConnected {
                List {
                    ForEach(BaseDeviceType.allCases, id: \.self) { baseDeviceType in
                        Section(baseDeviceType.rawValue) {
                            ForEach(DeviceType.allCases.filter() { deviceType in
                                return deviceType.baseDeviceType == baseDeviceType
                            }, id: \.self) { deviceType in
                                DeviceButtonView(deviceType: deviceType)
                            }
                        }
                    }
                }
                .navigationTitle("Rebill")
            } else {
                ZStack {
                    Color(UIColor.systemGray6)
                    VStack {
                        LoaderView(tintColor: .accentColor, scaleSize: 2.0)
                            .padding(.bottom, 16)
                        Text("Connecting ...")
                    }
                }
                .ignoresSafeArea()
            }
        }
    }
}

struct LoaderView: View {
    var tintColor: Color = .accentColor
    var scaleSize: CGFloat = 3.0
    
    var body: some View {
        ProgressView()
            .scaleEffect(scaleSize, anchor: .center)
            .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
    }
}

//struct DevicesView_Previews: PreviewProvider {
//    @StateObject static var measurements: MeasurementList = MeasurementList(measurements: [
//        Measurement(deviceType: DeviceType.tv, date: .now, consumption: 44.9),
//        Measurement(deviceType: DeviceType.oven, date: .now, consumption: 77),
//        Measurement(deviceType: DeviceType.hairdryer, date: .now, consumption: 12)
//    ])
//    static var previews: some View {
//        MeasureView()
//    }
//}
