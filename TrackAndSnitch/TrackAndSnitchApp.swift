//
//  TrackAndSnitchApp.swift
//  TrackAndSnitch
//
//  Created by Shatha Almukhaild on 27/03/1446 AH.
//

import SwiftUI

@main
struct TrackAndSnitchApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView() // Your root view
                    .navigationBarHidden(true) // Hide the navigation bar if needed
            }
        }
    }
}

