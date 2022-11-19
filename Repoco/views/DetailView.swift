//
//  DetailView.swift
//  HackaTUM
//
//  Created by Ragnar Fischer on 18.11.22.
//

import SwiftUI
import Charts

struct DetailView: View {
    
    @EnvironmentObject private var bleSession: BLESession
    
    var body: some View {
        List {
            Section(footer: Text("The score value is calculated from reference devices and lies between 0 (worst) and 100 (best).")) {
                HStack(alignment: .bottom) {
                    Text("75")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .scaleEffect(1.8)
                    Text("score points")
                        .padding(.leading, 21)
                }
                .padding(25)
                .padding(.leading)
                .listRowBackground(Color.orange.opacity(0.4))
            }
            Section {
                LabeledContent("Measurement date", value: dateToString(.now))
            }
            Section("Details") {
                LabeledContent("Measurement duration", value: "260 Seconds")
                LabeledContent("Average power consumption", value: "105 Watts")
                LabeledContent("Maximum power draw", value: "150 Watts")
                LabeledContent("Minimum power draw", value: "65 Watts")
            }
            Section {
                Button {
                    // TODO:
                } label: {
                    Text("Save to my history")
                }
            }
        }
        .navigationTitle("Refrigerator")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension DetailView {
    func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: date)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
