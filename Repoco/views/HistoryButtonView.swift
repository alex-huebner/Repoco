//
//  HistoryButtonView.swift
//  Repoco
//
//  Created by Alexander Huebner on 19.11.22.
//

import SwiftUI

struct HistoryButtonView: View {
    
    @State var name: String
    @State var subtitle: String
    @State var image: String
    
    var body: some View {
        NavigationLink {
            DetailView()
        } label: {
            HStack {
                Image(systemName: image)
                    .font(.largeTitle)
                VStack(alignment: .leading) {
                    Text(name)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text(subtitle)
                        .font(.footnote)
                }
                .padding(.leading, 10)
            }
            .padding(7)
        }
    }
}

struct HistoryButtonView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryButtonView(name: "Name", subtitle: "Untertitel", image: "Bild")
    }
}
