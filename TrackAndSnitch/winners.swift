//
//  winners.swift
//  TrackAndSnitch
//
//  Created by ALJOAHARAH SAUD ALSAYARI on 03/04/1446 AH.
//

import SwiftUI
import AVFoundation
import ConfettiSwiftUI

struct winners: View {
    @State private var flipped = false
    @State private var degree: Double = 0
    @State private var counter = 0
    @State private var glow = false
    @State private var player: AVPlayer? = nil // New AVPlayer instance
    // Custom color for the buttons
        let buttonColor = Color(UIColor(red: 107/255, green: 78/255, blue: 69/255, alpha: 1)) // #6B4E45
    
    var body: some View {
        ZStack {
            // Background Image
            Image("backgroundImage")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            // Background Stars
            VStack {
                HStack {
                    ShiningStar()
                        .frame(width: 50, height: 50)
                    Spacer()
                    ShiningStar()
                        .frame(width: 50, height: 50)
                }
                Spacer()
                HStack {
                    Spacer()
                    ShiningStar()
                        .frame(width: 50, height: 50)
                }
            }
            .padding(.all, 20)
            
            // Main Content
            VStack {
                Text("Congrats! \nYou've caught the thief")
                    .font(.headline)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                    .foregroundColor(Color(red: 0.979, green: 0.92, blue: 0.829)) // Adjust text color for visibility

                Spacer()

                ZStack {
                    if flipped {
                        CardFront(width: 260, height: 400, degree: $degree)
                    } else {
                        CardBack(width: 260, height: 400, degree: $degree)
                    }
                }
                .onTapGesture {
                    flipCard()
                    playSound() // Play sound when card is flipped
                }

                Spacer()

                HStack {
                                  Button("Play") {
                                      // Action for play
                                  }
                                  .padding()
                                  .background(buttonColor) // Updated button color
                                  .foregroundColor(.white)
                                  .cornerRadius(10)

                                  Button("Exit") {
                                      // Action for exit
                                  }
                                  .padding()
                                  .background(buttonColor) // Updated button color
                                  .foregroundColor(.white)
                                  .cornerRadius(10)
                              }
                .padding(.bottom, 20)
            }
            .confettiCannon(counter: $counter, repetitions: 3, repetitionInterval: 0.5)
        }
    }

    // Flip card function with animation
    func flipCard() {
        withAnimation(.easeInOut(duration: 0.8)) {
            if degree == 0 {
                degree = 180
            } else {
                degree = 0
            }
            flipped.toggle()
            counter += 1 // Triggers confetti
        }
    }

    // New AVPlayer-based function to play sound
    func playSound() {
        if let url = Bundle.main.url(forResource: "congratulations", withExtension: "mp3") {
            player = AVPlayer(url: url)
            player?.play()
        } else {
            print("Error: Could not find audio file.")
        }
    }
}

// Card Back struct
struct CardBack: View {
    let width: CGFloat
    let height: CGFloat
    @Binding var degree: Double

    var body: some View {
        ZStack {
            // Display the back card image
            Image("CardBack")
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .shadow(color: .gray, radius: 3, x: 0, y: 0)
        }
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
    }
}

// Card Front struct
struct CardFront: View {
    let width: CGFloat
    let height: CGFloat
    @Binding var degree: Double

    var body: some View {
        ZStack {
            // Display the front card content (you can modify this with your content)
            Text("Card Revealed")
                .font(.title)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 3, x: 0, y: 0)
        }
        .frame(width: width, height: height)
        .rotation3DEffect(Angle(degrees: degree - 180), axis: (x: 0, y: 1, z: 0))
    }
}

// Star Shape
struct ShiningStar: View {
    @State private var glow = false
    
    var body: some View {
        StarShape()
            .stroke(Color.red, lineWidth: 2)
            .background(StarShape().fill(Color.yellow))
            .shadow(color: Color.yellow.opacity(0.7), radius: glow ? 20 : 0)
            .scaleEffect(glow ? 1.2 : 1)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                    self.glow.toggle()
                }
            }
    }
}

struct StarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let pointsOnStar = 4
        var angle: CGFloat = -CGFloat.pi / 2

        let angleIncrement = .pi * 2 / CGFloat(pointsOnStar)

        let radius: CGFloat = min(rect.width, rect.height) / 2
        let innerRadius: CGFloat = radius * 0.5

        for i in 0..<pointsOnStar * 2 {
            let pointRadius = i % 2 == 0 ? radius : innerRadius
            let xPosition = center.x + cos(angle) * pointRadius
            let yPosition = center.y + sin(angle) * pointRadius
            if i == 0 {
                path.move(to: CGPoint(x: xPosition, y: yPosition))
            } else {
                path.addLine(to: CGPoint(x: xPosition, y: yPosition))
            }
            angle += angleIncrement / 2
        }
        path.closeSubpath()
        return path
    }
}

// SwiftUI Preview
struct winners_Previews: PreviewProvider {
    static var previews: some View {
        winners()
    }
}
