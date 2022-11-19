//
//  DetailView.swift
//  HackaTUM
//
//  Created by Ragnar Fischer on 18.11.22.
//

import SwiftUI

struct DetailView: View {
    
    @EnvironmentObject private var bleSession: BLESession
    
    var body: some View {
        List {
            LabeledContent("Watts", value: bleSession.watts ?? "---")
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
