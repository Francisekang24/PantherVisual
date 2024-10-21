//
//  SettingsView.swift
//  Panther's Visual
//
//  Created by Francisco Ele Ekang Mofuman on 4/6/24.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var isDarkModeOn = false
    @State private var isCameraOn = true
    @State private var isLocationOn = true
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Theme")) {
                        Toggle(isOn: $isDarkModeOn) {
                            Text("Dark mode")
                        }
                    }
                    Section(header: Text("Permits")) {
                        Toggle(isOn: $isCameraOn) {
                            Text("Camera")
                        }
                        Toggle(isOn: $isLocationOn) {
                            Text("Location")
                        }
                    }
                }
                .navigationBarTitle("Settings")
                .navigationBarItems(trailing:
                                        NavigationLink(destination: Help()) {
                    Image(systemName: "questionmark.circle")
                        .imageScale(.large)
                }
                )
            }
        }
        .tabItem {
            Label("Settings", systemImage: "gear")
        }
    }
}

#Preview {
    SettingsView()
}
