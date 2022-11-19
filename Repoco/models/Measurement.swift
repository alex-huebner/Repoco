//
//  Measurement.swift
//  Repoco
//
//  Created by Alexander Huebner on 19.11.22.
//

import Foundation

struct Measurement: Identifiable, Codable {
    let id: UUID
    var deviceType: DeviceType
    var date: Date
    var consumption: Int
    
    var measuredAvg: Int
    var measuredMax: Int
    var measuredMin: Int
    
    init(deviceType: DeviceType, date: Date, consumption: Int, measuredAvg: Int, measuredMax: Int, measuredMin: Int) {
        self.id = UUID()
        self.deviceType = deviceType
        self.date = date
        self.consumption = consumption
        self.measuredAvg = measuredAvg
        self.measuredMax = measuredMax
        self.measuredMin = measuredMin
    }
}


class MeasurementList: ObservableObject {
    @Published var measurements: [Measurement]
    
    init(measurements: [Measurement]) {
        self.measurements = measurements
    }
}

enum CodingKeys: CodingKey {
    case measurements
}
