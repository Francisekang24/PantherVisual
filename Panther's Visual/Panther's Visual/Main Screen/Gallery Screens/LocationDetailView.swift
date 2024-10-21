//
//  LocationDetailView.swift
//  Panther's Visual
//
//  Created by Francisco Ele Ekang Mofuman on 4/6/24.
//

import SwiftUI

struct LocationDetailView: View {
    var item: GalleryItem
    
    var body: some View {
        VStack(alignment: .leading) {
            TabView {
                ForEach(item.images, id: \.self) { img in
                    Image(uiImage: img)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .frame(height: 300)
            
            Text(item.name)
                .font(.title)
            Text("Founded: \(item.founded)")
            Text("Address: \(item.address)")
            Text(item.info)
                .padding()
        }
        .navigationBarTitle(Text(item.name), displayMode: .inline)
        .padding()
    }
}

/*
 #Preview {
 LocationDetailView()
 }
 */
