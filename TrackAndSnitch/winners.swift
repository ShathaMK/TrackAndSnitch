import SwiftUI
import AVFoundation
import ConfettiSwiftUI

struct WinnersView: View {
    @State private var flipped = false
    @State private var degree: Double = 0
    @State private var counter = 0
    @State private var player: AVPlayer? = nil
    @State private var playerNames = ["Player 1", "Player 2", "Player 3", "Player 4"] // Example player names
    var mostVotedPlayerRole: String? // Add this line
    var playerRole: String // Accept the player role as a parameter


    let buttonColor = Color(UIColor(red: 107/255, green: 78/255, blue: 69/255, alpha: 1))

    var body: some View {
        NavigationStack {  // Add NavigationStack for navigation
            ZStack {
                // Background Image
                Image("BackgroundImage")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                // Main Content
                VStack {
                    Text("Congrats! \nYou've caught the thief")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                        .foregroundColor(Color(red: 0.979, green: 0.92, blue: 0.829))

                    Spacer()

                    // ZStack for the card views
                    ZStack {
                        // Card Back
                        CardBackW(width: 260, height: 400, degree: $degree)
                            .opacity(flipped ? 0 : 1) // Fade out when flipped

                        // Card Front
                        CardFrontW(width: 260, height: 400, degree: $degree)
                            .opacity(flipped ? 1 : 0) // Fade in when flipped
                    }
                    .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0)) // Apply rotation to both cards
                    .onTapGesture {
                        flipCard()
                        playSound()
                    }

                    Spacer()

                    HStack {
                        NavigationLink(destination: GameView(playerNames: playerNames)) {  // Navigate to GameView for "Play again" with player names
                            Text("Play again")
                                .padding()
                                .background(buttonColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        NavigationLink(destination: playersView()) {  // Navigate to playersView for "Change players"
                            Text("Change players")
                                .padding()
                                .background(buttonColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.bottom, 20)
                }
                .confettiCannon(counter: $counter, repetitions: 3, repetitionInterval: 0.5)
            }
        }
    }

    func flipCard() {
        withAnimation(.easeInOut(duration: 0.4)) {
            degree = flipped ? 0 : 180
            flipped.toggle()
            counter += 1 // Triggers confetti
        }
    }

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
struct CardBackW: View {
    let width: CGFloat
    let height: CGFloat
    @Binding var degree: Double

    var body: some View {
        ZStack {
            Image("CardBack")
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .shadow(color: .gray, radius: 3, x: 0, y: 0)
        }
    }
}

// Card Front struct
struct CardFrontW: View {
    let width: CGFloat
    let height: CGFloat
    @Binding var degree: Double

    var body: some View {
        ZStack {
            Image("Thief_")
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .shadow(color: .gray, radius: 3, x: 0, y: 2)
        }
    }
}

struct WinnersView_Previews: PreviewProvider {
    static var previews: some View {
        WinnersView(playerRole: "Thief") // Sample role
    }
}
