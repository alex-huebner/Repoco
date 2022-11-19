//
//  Measurement.swift
//  Repoco
//
//  Created by Alexander Huebner on 19.11.22.
//

import Foundation

struct Measurement: Identifiable {
    let id: UUID
    var deviceType: DeviceType
    var name: String
    var consumption: Double
    
    init(deviceType: DeviceType, name: String, consumption: Double) {
        self.id = UUID()
        self.deviceType = deviceType
        self.name = name
        self.consumption = consumption
    }
}


class MeasurementList: ObservableObject {
    @Published var measurements: [Measurement]
    
    init(measurements: [Measurement]) {
        self.measurements = measurements
    }
}
