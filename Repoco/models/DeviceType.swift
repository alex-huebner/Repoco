//
//  DeviceType.swift
//  Repoco
//
//  Created by Alexander Huebner on 19.11.22.
//

import Foundation

enum DeviceType: String, CustomStringConvertible, CaseIterable, Codable {
    case washingMachine = "Washing Machine"
    case oven = "Oven"
    case dryer = "Dryer"
    case refrigerator = "Refrigerator"
    case airConditioner = "Air Conditioner"
    case microwave = "Microwave"
    case toaster = "Toaster"
    case hairdryer = "Hairdryer"
    case tv = "Television"
    case generic = "Generic Device"
    
    var avgConsumption: Int {
        switch self {
            case .washingMachine:
                return 500
            case .oven:
                return 500
            case.dryer:
                return 500
            case .refrigerator:
                return 500
            case .airConditioner:
                return 500
            case .microwave:
                return 500
            case .toaster:
                return 500
            case .hairdryer:
                return 500
            case.tv:
                return 500
            case .generic:
                return 500
        }
    }
    
    var description: String {
        switch self {
            case .washingMachine:
                return "washer"
            case .oven:
                return "oven"
            case.dryer:
                return "dryer"
            case .refrigerator:
                return "door.french.closed"
            case .airConditioner:
                return "air.conditioner.vertical"
            case .microwave:
                return "microwave"
            case .toaster:
                return "filemenu.and.selection"
            case .hairdryer:
                return "humidity"
            case.tv:
                return "sparkles.tv"
            case .generic:
                return "bolt"
        }
    }
    
    var baseDeviceType: BaseDeviceType {
        switch self {
            case .washingMachine:
                return BaseDeviceType.bigDevices
            case .oven:
                return BaseDeviceType.bigDevices
            case.dryer:
                return BaseDeviceType.bigDevices
            case .refrigerator:
                return BaseDeviceType.bigDevices
            case .airConditioner:
                return BaseDeviceType.bigDevices
            case .microwave:
                return BaseDeviceType.smallDevices
            case .toaster:
                return BaseDeviceType.smallDevices
            case .hairdryer:
                return BaseDeviceType.smallDevices
            case.tv:
                return BaseDeviceType.other
            case .generic:
            return BaseDeviceType.other
        }
    }
}

enum BaseDeviceType: String, CaseIterable, Codable {
    case bigDevices = "Large Appliances"
    case smallDevices = "Small Appliances"
    case other = "Others"
}
