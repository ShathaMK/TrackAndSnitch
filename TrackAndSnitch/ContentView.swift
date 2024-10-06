//
//  ContentView.swift
//  TrackAndSnitch
//
//  Created by Shatha Almukhaild on 27/03/1446 AH.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showNewView = false
    var body: some View {


        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
