//
//  CameraView.swift
//  Panther's Visual
//
//  Created by Francisco Ele Ekang Mofuman on 4/6/24.
//

import SwiftUI

struct CameraView: View {
    
    @State private var isGallery = false
    @State private var isCamera = false
    
    @State private var isMatchFound = false
    @State private var image: UIImage?
    @State private var Class: String?
    @State private var Item: GalleryItem?
    
    @EnvironmentObject var viewModel: FirebaseManager
    
    var body: some View {
        
        VStack {
            
            NavigationView{
                NavigationLink(destination: LocationDetailView(item: viewModel.IDdictionary[Class ?? ""] ?? EmptyItem)){
                    VStack{
                        Text(Class ?? "")
                            .multilineTextAlignment(.center)
                            .font(.custom("Marker Felt Thin", size: 40.0))
                        image.map {
                            Image(uiImage: $0)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                                .cornerRadius(5)
                            
                        }
                    }
                }
            }
            
            
            HStack {
                Button(action: {
                    self.isGallery.toggle()
                }) {
                    VStack {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.title)
                            .foregroundColor(.blue)
                        Text("Gallery")
                    }
                }.padding()
                
                Button(action: {
                    self.isCamera.toggle()
                }) {
                    VStack {
                        Image(systemName: "camera")
                            .font(.title)
                            .foregroundColor(.blue)
                        Text("Camera")
                    }
                }.padding()
                    .disabled(!UIImagePickerController.isSourceTypeAvailable(.camera))
            }
            
            .sheet(isPresented: $isGallery) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image, classID: self.$Class)
            }
            .sheet(isPresented: $isCamera) {
                ImagePicker(sourceType: .camera, selectedImage: self.$image, classID: self.$Class)
            }
            
            .tabItem {
                Label("Camera", systemImage: "camera")
            }
        }
    }
    
    private func results() -> GalleryItem {
        for item in viewModel.galleryItems {
            print(item.ID)
                return EmptyItem
            }
        
        return EmptyItem
    }
}

#Preview {
    CameraView()
}

