//
//  HomeView.swift
//  Panther's Visual
//
//  Created by Francisco Ele Ekang Mofuman on 4/6/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack (spacing: 1) {
            
            Image("LOGO")
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .cornerRadius(12)
            
            Text("Panther's \nVisual")
                .multilineTextAlignment(.center)
                .font(.custom("Marker Felt Thin", size: 60.0))
            
            Image("HOME_IMAGE")
                .resizable()
                .scaledToFit()
                .frame(height: 250)
                .cornerRadius(12)
            
            Text("Everything you need to know \nabout the PVAMU campus")
                .font(.custom("Rockwell", size: 22.0))
            
        }
            .tabItem {
                Label("Home", systemImage: "house")
            }
    }
}

#Preview {
    HomeView()
}
