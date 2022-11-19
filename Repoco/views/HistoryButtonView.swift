//
//  HistoryButtonView.swift
//  Repoco
//
//  Created by Alexander Huebner on 19.11.22.
//

import SwiftUI

struct HistoryButtonView: View {
    
    var name: String
    var subtitle: String
    var image: String
    var measurement: Measurement
    
    var body: some View {
        NavigationLink {
            DetailView(measurement: measurement, deviceType: measurement.deviceType)
        } label: {
            HStack {
                Image(systemName: image)
                    .font(.largeTitle)
                    .foregroundColor(getColorForScore(getScore(measurement.measuredAvg, deviceType: measurement.deviceType) ?? -1))
                VStack(alignment: .leading) {
                    Text(name)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text(subtitle)
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                }
                .padding(.leading, 10)
            }
            .padding(7)
        }
    }
}

//struct HistoryButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoryButtonView(name: "Name", subtitle: "Untertitel", image: "Bild", measurement: Measurement(deviceType: .oven, date: .now, consumption: 44))
//    }
//}
