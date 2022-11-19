//
//  DeviceButtonView.swift
//  HackaTUM
//
//  Created by Ragnar Fischer on 19.11.22.
//

import SwiftUI

struct DeviceButtonView: View {
    
    var deviceType: DeviceType
    
    var body: some View {
        NavigationLink {
            DetailView(deviceType: deviceType)
        } label: {
            HStack {
                Image(systemName: deviceType.description)
                    .font(.largeTitle)
                    .foregroundColor(.accentColor)
                Text(deviceType.rawValue)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.leading, 10)
            }
            .padding(7)
        }
    }
}

struct DeviceButtonView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceButtonView(deviceType: .oven)
    }
}
