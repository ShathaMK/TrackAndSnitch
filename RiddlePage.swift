import SwiftUI
import AVFoundation

// Struct for the card front
struct RiddleFront: View {
    let width: CGFloat
    let height: CGFloat
    @Binding var degree: Double
    let riddle: String

    var body: some View {
        ZStack {
            // Display the front card image
            Image("Rectangle")
                .resizable()
                .scaledToFill()
                .frame(width: 260, height: 400)
                .shadow(color: .gray, radius: 3, x: 0, y: 2)

            Text(riddle)
                .foregroundStyle(Color(hex: 0x902A39))
                .font(.system(.title3, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 90)
        } // End of ZStack
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
    }
}

struct RiddlePage: View {
    let playerRole: String // Player role to be passed to WinnersView

    @ObservedObject var playersData = PlayersData.shared  // Access PlayersData from the environment
    @State var selectedItem: Item // The selected item passed from the previous view

    // The degree of rotation for the back of the card
    @State var backDegree = 0.0
    // The degree of rotation for the front of the card
    @State var frontDegree = -90.0
    // A boolean that keeps track of whether the card is flipped or not
    @State var isFlipped = false
    // The width of the card
    let width: CGFloat = 200
    // The height of the card
    let height: CGFloat = 250
    // The duration and delay of the flip animation
    let durationAndDelay: CGFloat = 0.3
    // Timer variables
    @State private var timeRemaining = 15
    @State private var currentRiddleIndex: Int = 0
    @State private var isActive = true
    @State private var currentRiddles: [String] = []

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Environment(\.scenePhase) var scenePhase

    // New state variable for navigation
    @State private var navigateToVoting = false

    var body: some View {
//        NavigationView { // Ensure there's a NavigationView to handle navigation
            ZStack {
                // Background color
                Color(hex: 0xE9DFCF).ignoresSafeArea()

                VStack {
                    Text("Round - 1")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.semibold)
                        .padding(.top, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                        .padding(.bottom, 30)

                    Text("⏳" + convertSecondsToTime(timeInSeconds: timeRemaining))
                        .font(.title)
                        .foregroundStyle(Color(hex: 0x902A39))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .background(Color(hex: 0xFFEEB3).opacity(0.45))
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(Color(hex: 0xE1A86C), lineWidth: 1)
                        )

                    Spacer()

                    // Card flip area
                    ZStack {
                        // Card Front
                        if currentRiddleIndex < currentRiddles.count {
                            RiddleFront(
                                width: width,
                                height: height,
                                degree: $frontDegree,
                                riddle: currentRiddles[currentRiddleIndex]
                            )
                        }

                        // Card Back
                        CardBack(width: width, height: height, degree: $backDegree)
                    }
                    .onTapGesture {
                        flipCard()
                    }

                    Text("Here's a riddle")
                        .font(.system(.callout, design: .rounded))
                        .padding(.top, 25)

                    Spacer()

                    // Show "Next Riddle" button only if there are more riddles
                    if currentRiddleIndex < currentRiddles.count - 1 {
                        Button(action: {
                            showNextRiddle()
                        }) {
                            Text("Next Riddle")
                                .frame(width: 260, height: 45)
                                .background(Color(hex: 0x6B4F44))
                                .foregroundStyle(.white)
                                .cornerRadius(10)
                        }
                        .padding(.bottom, 40)
                    }
                    // Removed the "Continue" button after the last riddle

                    Spacer()
                }
                .foregroundColor(Color(hex: 0x6B4F44))
            }
            .navigationBarBackButtonHidden(true) // Remove the back button
            .onAppear {
                // Populate playersNames if empty
                if playersData.playersNames.isEmpty {
                    playersData.playersNames = PlayerRoleStorage.shared.getRoles().map { $0.0 }
                    print("playersData.playersNames initialized with: \(playersData.playersNames)")
                }
                
                // Randomly select two riddles from the selected item's riddles
                currentRiddles = Array(selectedItem.riddles.shuffled().prefix(2))
                currentRiddleIndex = 0
                // Reset flip state
                isFlipped = false
                backDegree = 0
                frontDegree = -90
            }
            .onReceive(timer) { _ in
                guard isActive else { return }
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    // Timer finished, navigate to VotingItemsView
                    isActive = false
                    navigateToVoting = true
                }
            }
            .onChange(of: scenePhase) { phase in
                isActive = phase == .active
            }
            .background(
                // NavigationLink to navigate programmatically
                NavigationLink(
                    destination: VotingItemsView(selectedItem: selectedItem, playerRole: playerRole),
                    isActive: $navigateToVoting
                ) {
                    EmptyView()
                }
            )
//        } // End of NavigationView
    }

    func convertSecondsToTime(timeInSeconds: Int) -> String {
        // To get the minutes and seconds from total seconds
        let minutes = timeInSeconds / 60
        let seconds = timeInSeconds % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }

    func flipCard() {
        playSound()
        isFlipped.toggle()
        if isFlipped {
            withAnimation(.linear(duration: durationAndDelay)) {
                backDegree = 90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
                frontDegree = 0
            }
        } else {
            withAnimation(.linear(duration: durationAndDelay)) {
                frontDegree = -90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
                backDegree = 0
            }
        }
    }

    func showNextRiddle() {
        if currentRiddleIndex < currentRiddles.count - 1 {
            currentRiddleIndex += 1
            // Reset the flip state when showing the next riddle
            isFlipped = false
            backDegree = 0
            frontDegree = -90
        }
        // Removed navigation to the next page
    }

    // Implement playSound()
    func playSound() {
        if let url = Bundle.main.url(forResource: "flipcard-91468", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer.play()
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        } else {
            print("Sound file not found.")
        }
    }
}

struct RiddlePage_Previews: PreviewProvider {
    static var previews: some View {
        let sampleItem = Item(
            name: "Sample Item",
            riddles: ["Riddle 1", "Riddle 2"]
        )
        
        // Initialize PlayerRoleStorage with sample roles
        PlayerRoleStorage.shared.saveRoles([
            ("Player 1", "Tracker"),
            ("Player 2", "Thief"),
            ("Player 3", "Tracker"),
            ("Player 4", "Trickster")
        ])
        
        // Retrieve a specific playerRole (e.g., Player 1's role)
        let samplePlayerRole = "Thief"
        
        return RiddlePage(playerRole: samplePlayerRole, playersData: PlayersData.shared, selectedItem: sampleItem)
    }
}
