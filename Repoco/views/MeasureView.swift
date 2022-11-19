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
                            }, id: \.self) { baseDeviceType in
                                DeviceButtonView(name: baseDeviceType.rawValue,  image: baseDeviceType.description)
                            }
                        }
                    }
                }
                .navigationTitle("Rebill")
            } else {
                Text("Connecting...")
            }
        }
    }
}

struct DevicesView_Previews: PreviewProvider {
    static var previews: some View {
        MeasureView()
    }
}
