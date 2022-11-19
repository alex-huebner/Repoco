//
//  utilities.swift
//  Repoco
//
//  Created by Alexander Huebner on 19.11.22.
//

import Foundation
import SwiftUI

func getColorForScore(_ score: Int) -> Color {
    if (score == -1) {
        return Color(UIColor.systemGray4)
    } else if (0 <= score && score <= 25) {
        return Color.red
    } else if (25 < score && score <= 50) {
        return Color.orange
    } else if (50 < score && score <= 75) {
        return Color.yellow
    } else {
        return Color.green
    }
}

func getScore(_ consumption: Int?, deviceType: DeviceType) -> Int? {
    guard let consumption = consumption else {
        return nil
    }
    print("Opt: " + String(deviceType.avgConsumption))
    print("Consumption: " + String(consumption))
    var score = Double(deviceType.avgConsumption) / Double(consumption)
    print("Score: " + String(score))
    if score > 1 {
        score = 1
    }
    return Int(score * 100)
}
