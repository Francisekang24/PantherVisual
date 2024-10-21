//
//  GalleryView.swift
//  Panther's Visual
//
//  Created by Francisco Ele Ekang Mofuman on 4/6/24.
//

import SwiftUI

struct GalleryView: View {
    
    @EnvironmentObject var viewModel: FirebaseManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 5) {
                // NavigationLink for Buildings
                NavigationLink(destination: CategoryView(type: "Building", items: viewModel.galleryItems.filter{$0.type == "Building"})) {
                    categoryButton(imageName: "Business_0", title: "Buildings")
                }
                
                // NavigationLink for Sculptures
                NavigationLink(destination: CategoryView(type: "Sculpture", items: viewModel.galleryItems.filter {$0.type == "Sculpture"})) {
                    categoryButton(imageName: "Panther_0", title: "Sculptures")
                }
                
                // NavigationLink for Infrastructure
                NavigationLink(destination: CategoryView(type: "Infrastructure", items: viewModel.galleryItems.filter {$0.type == "Infrastructure"})) {
                    categoryButton(imageName: "Stadium_0", title: "Infrastructures")
                }
            }
            .navigationBarTitle("Gallery", displayMode: .inline)
        }
        .tabItem {
            Label("Gallery", systemImage: "photo.on.rectangle.angled")
        }
        .onAppear {
            //viewModel.fetchGalleryItems()
        }
    }

    // Helper function to create category buttons
    private func categoryButton(imageName: String, title: String) -> some View {
        ZStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 373, height: 206)
                .clipped()
                .cornerRadius(9)

            Text(title)
                .foregroundColor(.white)
                .font(.custom("Marker Felt Thin", size: 50.0))
        }
    }

    
   
}

#Preview {
    GalleryView()
}
