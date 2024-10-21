//
//  Help.swift
//  Panther's Visual
//
//  Created by Francisco Ele Ekang Mofuman on 4/14/24.
//

import SwiftUI

struct Help: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("How it works")
                .font(.title)
                .padding()
            Text("Aim your phone’s camera to the sculpture or the building you want to know about. Please take a picture of it. If the app has a result from your oicture tap the picture, and the app will provide you with details like the name, the foundation date, the founder, and more exciting info.")
                .padding()
            Text("References")
                .font(.title)
                .padding()
            Text("The information provided in this app is taken from the Prairie View A&M University Library Database official website.")
                .padding()
            Spacer()
        }
        .navigationBarTitle("Help", displayMode: .inline)
    }
}



#Preview {
    Help()
}
