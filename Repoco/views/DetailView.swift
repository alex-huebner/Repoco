//
//  DetailView.swift
//  HackaTUM
//
//  Created by Ragnar Fischer on 18.11.22.
//

import SwiftUI
import Charts

struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject private var bleSession: BLESession
    @EnvironmentObject var measurements: MeasurementList
    
    @State private var powerPoints: [Int] = []
    @State var measurement: Measurement?
    
    var deviceType: DeviceType
    
    var body: some View {
        List {
            Section(footer: Text("The score value is calculated from reference devices and lies between 0 (worst) and 100 (best).")) {
                HStack(alignment: .bottom) {
                    Text(getScore(getAverage()) != nil ? String(getScore(getAverage())!) : "--")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .scaleEffect(1.8)
                    Text("score points")
                        .padding(.leading, 21)
                }
                .padding(25)
                .padding(.leading)
                .listRowBackground(getColorForScore(getScore(getAverage()) ?? -1))
            }
            Section {
                LabeledContent("Measurement date", value: dateToString(measurement?.date ?? .now))
            }
            Section("Details") {
                LabeledContent(
                    "Average power consumption",
                    value: getAverage() != nil ? String(getAverage()!) + " Watts" : "--")
                LabeledContent("Maximum power draw", value: getMax() != nil ? String(getMax()!) + " Watts" : "--")
                LabeledContent("Minimum power draw", value: getMin() != nil ? String(getMin()!) + " Watts" : "--")
            }
            Section {
                Button(action: saveMeasurement, label: {
                    Text("Save to my history")
                }).disabled(measurement != nil)
            }
        }
        .onChange(of: bleSession.watts ?? "1", perform: { newValue in
            if Int(newValue) ?? 0 > 0 {
                powerPoints.append(Int(newValue)!)
            }
        })
        .navigationTitle(deviceType.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension DetailView {
    func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: date)
    }

    func getScore(_ consumption: Int?) -> Int? {
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
    
    func getAverage() -> Int? {
        if measurement != nil {
            return measurement?.measuredAvg
        }
        if powerPoints.count == 0 {
            return nil
        }
        let powerTotal = powerPoints.reduce(0, +)
        return powerTotal / powerPoints.count
    }
    
    func getMax() -> Int? {
        if measurement != nil {
            return measurement?.measuredMax
        }
        return powerPoints.max()
    }
    
    func getMin() -> Int? {
        if measurement != nil {
            return measurement?.measuredMin
        }
        return powerPoints.min()
    }
    
    func saveMeasurement() -> Void {
        let newMeasurement = Measurement(
            deviceType: deviceType,
            date: .now,
            consumption: getAverage() ?? 0,
            measuredAvg: getAverage() ?? 0,
            measuredMax: powerPoints.max() ?? 0,
            measuredMin: powerPoints.min() ?? 0
        )
        
        measurements.measurements.append(newMeasurement)
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(measurements.measurements) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "measurements")
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

//struct DetailView_Previews: PreviewProvider {
//    @StateObject static var measurements: MeasurementList = MeasurementList(measurements: [
//        Measurement(
//            deviceType: DeviceType.tv,
//            date: .now,
//            consumption: 44.9
//        ),
//        Measurement(deviceType: DeviceType.oven, date: .now, consumption: 77),
//        Measurement(deviceType: DeviceType.hairdryer, date: .now, consumption: 12)
//    ])
//
//    static var previews: some View {
//        DetailView(measurement: Measurement(deviceType: .oven, date: .now, consumption: 150), deviceType: .oven)
//            .environmentObject(measurements)
//    }
//}
