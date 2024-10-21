//
//  ContentView.swift
//  Panther's Visual
//
//  Created by Francisco Ele Ekang Mofuman on 4/6/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                Label("Home", systemImage: "house")
            }
            CameraView()
                .tabItem {
                Label("Camera", systemImage: "camera")
            }
            GalleryView()
                .tabItem {
                Label("Gallery", systemImage: "photo.on.rectangle.angled")
            }
            SettingsView()
                .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

