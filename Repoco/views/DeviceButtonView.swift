//
//  DeviceButtonView.swift
//  HackaTUM
//
//  Created by Ragnar Fischer on 19.11.22.
//

import SwiftUI

struct DeviceButtonView: View {
    
    @State var name: String
    @State var image: String
    
    var body: some View {
        NavigationLink {
            DetailView()
        } label: {
            HStack {
                Image(systemName: image)
                    .font(.largeTitle)
                Text(name)
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
        DeviceButtonView(name: "Name", image: "Bild")
    }
}
