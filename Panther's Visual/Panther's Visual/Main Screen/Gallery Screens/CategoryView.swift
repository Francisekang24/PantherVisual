//
//  GategoryView.swift
//  Panther's Visual
//
//  Created by Francisco Ele Ekang Mofuman on 4/6/24.
//

import SwiftUI

struct CategoryView: View {
    
    
    var type: String
    var items: [GalleryItem]
    
    var body: some View {
        List(items) { item in
            NavigationLink(destination: LocationDetailView(item: item)) {
                HStack {
                    if let image = item.images.first {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        Text(item.info)
                            .font(.subheadline)
                            .lineLimit(1)
                    }
                }
            }
        }
        .navigationTitle(type)
    }
}

/*
#Preview {
    CategoryView()
}
*/
