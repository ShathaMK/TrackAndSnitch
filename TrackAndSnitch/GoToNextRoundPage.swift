//
//  GoToNextRoundPage.swift
//  TrackAndSnitch
//
//  Created by Whyyy on 01/10/2024.
//

import SwiftUI

struct GoToNextRoundPage: View {
    var body: some View {
        ZStack {
            // Background Color
            Image("bgpaper") // backgoround img
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Content inside a rounded rectangle
                VStack(spacing: 25) {
                    // Icon at the top
                    Image("hacker") // Placeholder icon
                        .resizable()
                        .frame(width: 100, height: 95)
                        .foregroundColor(Color(red: 0.57, green: 0.24, blue: 0.24))
                        .padding(.top, 20)
                    
                    // The Main Text
                    Text("The item is\nstill stolen")
                        .font(.system(size: 34, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(red: 0.57, green: 0.24, blue: 0.24))
                        .multilineTextAlignment(.center)
                    
                    // Sub Text
                    Text("You're all close to finding\n it, get ready for round 2!")
                        .font(.system(size: 20, weight: .regular, design: .rounded))
                        .foregroundColor(Color(red: 0.42, green: 0.34, blue: 0.28))
                        .multilineTextAlignment(.center)
                        .padding([.leading, .bottom, .trailing], 30)
                    
                    // Button to start round 2
                    Button(action: {
                        // Action when the button is pressed
                    }) {
                        Text("Start Round 2")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.42, green: 0.34, blue: 0.28))
                            .cornerRadius(20)
                            .padding(.horizontal, 40)
                    }
                    .padding(.bottom)
                }
                .padding()
                .background(Color(red: 0.89, green: 0.83, blue: 0.75)) // Light beige rectangle
                .cornerRadius(20) // Rounded corners for the rectangle
                .padding(.horizontal, 45) // Padding for the whole rectangle
                
                Spacer()
            }
        }    }
}

#Preview {
    GoToNextRoundPage()
}
