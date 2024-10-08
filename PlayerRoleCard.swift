//
//  PlayerRoleCard.swift
//  TrackAndSnitch
//
//  Created by Shatha Almukhaild on 28/03/1446 AH.
//

import SwiftUI
import AVFoundation

var audioPlayer: AVAudioPlayer!

// Function to play the sound
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

class PlayerRoleStorage {
    static let shared = PlayerRoleStorage() // Singleton instance to allow global access
    private(set) var assignedPlayerRoles: [(String, String)] = [] // Tuple to store player names and roles

    func saveRoles(_ roles: [(String, String)]) {
        assignedPlayerRoles = roles
    }

    func getRoles() -> [(String, String)] {
        return assignedPlayerRoles
    }
}


// Define data models
struct Item {
    let name: String
    let riddles: [String]
}


// Define type aliases for clarity
typealias Role = (title: String, imageName: String)
typealias RoleConfiguration = [Role]

// Function to parse a CSV line, considering that the riddles might contain commas
func parseCSVLine(_ line: String) -> [String] {
    var result: [String] = []
    var currentField = ""
    var insideQuotes = false

    for character in line {
        if character == "\"" {
            insideQuotes.toggle()
        } else if character == "," && !insideQuotes {
            result.append(currentField)
            currentField = ""
        } else {
            currentField.append(character)
        }
    }
    result.append(currentField)

    return result
}

//most voted player's role
var mostVotedPlayerRole: String = "" // Store the most voted player's role

// Function to read items and riddles from CSV file
func readCSV(fileName: String) -> [Item] {
    var items: [Item] = []

    if let filepath = Bundle.main.path(forResource: "db7", ofType: "csv") {
        do {
            let contents = try String(contentsOfFile: filepath, encoding: .utf8)
            let lines = contents.components(separatedBy: "\n").filter { !$0.isEmpty }

            guard !lines.isEmpty else {
                print("CSV file is empty")
                return []
            }

            // Skip the first line if it contains headers
            let dataLines = lines.dropFirst()

            for line in dataLines {
                // Use the parseCSVLine function to handle commas within fields
                let components = parseCSVLine(line)

                if components.count >= 2 {
                    let itemName = components[0]
                    let riddles = Array(components[1...]) // Get all riddles
                    items.append(Item(name: itemName, riddles: riddles))
                } else {
                    print("Invalid line in CSV: \(line)")
                }
            }
        } catch {
            print("Error reading file: \(error.localizedDescription)")
        }
    } else {
        print("File not found: \(fileName).csv")
    }

    return items
}

// Function to create players
func createPlayers(playerNames: [String]) -> (players: [Player], selectedItem: Item)? {
    let numberOfPlayers = playerNames.count
    //
    //    // Generate player names
    //    var playerNames: [String] = []
    //    for i in 1...numberOfPlayers {
    //        playerNames.append("Player \(i)")
    //    }
    
    // Read items and riddles from db7.csv
    let items = readCSV(fileName: "db7")
    
    // Check if items are available
    guard !items.isEmpty else {
        print("No items found in db7.csv")
        return nil
    }
    
    // Randomly select an item
    let selectedItem = items.randomElement()!
    
    // Define role configurations separately, incorporating the selected item
    let rolesFor2Players: RoleConfiguration = [
        ("Tracker", "Trackers_"),
        ("\n\n\n\n\n\nThief", "Thief_")
    ]
    
    let rolesFor3Players: RoleConfiguration = [
        ("Tracker", "Trackers_"),
        ("Tracker", "Trackers_"),
        ("\n\n\n\n\n\nThief", "Thief_")
    ]
    
    let rolesFor4Players: RoleConfiguration = [
        ("Tracker", "Trackers_"),
        ("Tracker", "Trackers_"),
        ("Tracker", "Trackers_"),
        ("\n\n\n\n\n\nThief", "Thief_")
    ]
    
    let rolesFor5Players: RoleConfiguration = [
        ("Tracker", "Trackers_"),
        ("Tracker", "Trackers_"),
        ("Tracker", "Trackers_"),
        ("\n\n\n\n\n\nThief", "Thief_"),
        ("Trickster", "Trickster_")
    ]
    
    let rolesFor6Players: RoleConfiguration = [
        ("Tracker", "Trackers_"),
        ("Tracker", "Trackers_"),
        ("Tracker", "Trackers_"),
        ("\n\n\n\n\n\n\n\n\nHelper", "Helper_"),
        ("\n\n\n\n\n\nThief", "Thief_"),
        ("Trickster", "Trickster_")
    ]
    
    let rolesFor7Players: RoleConfiguration = [
        ("Tracker", "Trackers_"),
        ("Tracker", "Trackers_"),
        ("Tracker", "Trackers_"),
        ("Tracker", "Trackers_"),
        ("\n\n\n\n\n\nHelper", "Helper_"),
        ("\n\n\n\n\n\nThief", "Thief_"),
        ("Trickster", "Trickster_")
    ]
    
    let rolesFor8Players: RoleConfiguration = [
        ("Tracker", "Trackers_"),
        ("Tracker", "Trackers_"),
        ("Tracker", "Trackers_"),
        ("Tracker", "Trackers_"),
        ("Tracker", "Trackers_"),
        ("\n\n\n\n\n\nHelper", "Helper_"),
        ("\n\n\n\n\n\nThief", "Thief_"),
        ("Trickster", "Trickster_")
    ]
    
    let rolesFor9Players: RoleConfiguration = [
        ("Tracker", "Trackers_"),
        ("Tracker", "Trackers_"),
        ("Tracker", "Trackers_"),
        ("Tracker", "Trackers_"),
        ("Tracker", "Trackers_"),
        ("Tracker", "Trackers_"),
        ("\n\n\n\n\n\nHelper", "Helper_"),
        ("\n\n\n\n\n\nThief", "Thief_"),
        ("Trickster", "Trickster_")
    ]
    
    let rolesFor10Players: RoleConfiguration = [
        ("Tracker", "Trackers_"),
        ("Tracker", "Trackers_"),
        ("Tracker", "Trackers_"),
        ("Tracker", "Trackers_"),
        ("Tracker", "Trackers_"),
        ("Tracker", "Trackers_"),
        ("Tracker", "Trackers_"),
        ("\n\n\n\n\n\nHelper", "Helper_"),
        ("\n\n\n\n\n\nThief", "Thief_"),
        ("Trickster", "Trickster_")
    ]
    
    // Assemble the roles array
    let rolesArray: [RoleConfiguration] = [
        rolesFor2Players,
        rolesFor3Players,
        rolesFor4Players,
        rolesFor5Players,
        rolesFor6Players,
        rolesFor7Players,
        rolesFor8Players,
        rolesFor9Players,
        rolesFor10Players
    ]
    
    // Ensure valid number of players
    guard numberOfPlayers >= 2, numberOfPlayers <= rolesArray.count + 2 else {
        print("Invalid number of players. Must be between 2 and \(rolesArray.count + 2).")
        return nil
    }
    
    // Get the roles for the current number of players
    let assignedRoles = rolesArray[numberOfPlayers - 2] // Get the roles for the current number of players
    
    // Shuffle the roles before assigning them to players
    let shuffledRoles = assignedRoles.shuffled()
    
    var players: [Player] = []
    
    for (index, name) in playerNames.enumerated() {
        if index < shuffledRoles.count {
            let role = shuffledRoles[index]
            players.append(Player(name: name, cardImage: role.imageName, title: role.title))
        } else {
            // Assign default role if roles are fewer than players
            players.append(Player(name: name, cardImage: "Trackers_", title: "Tracker"))
        }
    }
    // Store the assigned roles in the PlayerRoleStorage singleton
    PlayerRoleStorage.shared.saveRoles(players.map { ($0.name, $0.title) }) // newly added to send the roles over to the next pages

    return (players, selectedItem)
}


// Player model
struct Player {
    let name: String
    // Name of the card image
    let cardImage: String
    // Title of the card
    let title: String
}

// Struct for the card front
struct CardFront: View {
    // The width of the card
    let width: CGFloat
    // The height of the card
    let height: CGFloat
    // Card front image
    let imageName: String

    // The degree of rotation for the card
    @Binding var degree: Double

    var body: some View {

        ZStack {
            // Display the front card image
            Image(imageName)
                .resizable()
                .frame(width: 260, height: 400)
                .scaledToFill()
                .cornerRadius(10)
                .shadow(color: .gray, radius: 3, x: 0, y: 2)
            // The radius is the shadow all around the card
            // x is the shadow on the right
            // y is the shadow on the bottom
        } // End of ZStack
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
        // The x, y, and z represent the direction of the flip
    }
}

// Struct for the card back
struct CardBack: View {
    // The width of the card
    let width: CGFloat
    // The height of the card
    let height: CGFloat
    // The degree of rotation for the card
    @Binding var degree: Double

    var body: some View {

        ZStack {
            // Display the back card image
            Image("CardBack")
                .resizable()
                .scaledToFill()
                .frame(width: 260, height: 400)
                .shadow(color: .gray, radius: 3, x: 0, y: 0)
            // The radius is the shadow all around the card
            // x is the shadow on the right
            // y is the shadow on the bottom

        }
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
        // The x, y, and z represent the direction of the flip
    }
}

// Main view for player role cards
struct PlayerRoleCard: View {
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

    // Player management
    @State private var currentPlayerIndex = 0
    let players: [Player]
    let selectedItem: Item
    // This state variable will determine if all player roles are assigned
    @State private var allRolesAssigned = false

    // A function that flips the card by updating the degree of rotation for the front and back of the card
    func flipCard() {
        playSound()
        isFlipped.toggle()
        if isFlipped {

            withAnimation(.linear(duration: durationAndDelay)) {
                backDegree = 90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                frontDegree = 0
            }
        } else {
            withAnimation(.linear(duration: durationAndDelay)) {
                frontDegree = -90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                backDegree = 0
            }
        }
    }

    func nextPlayer() {
        // Check if there are more players to show
        if currentPlayerIndex < players.count - 1 {
            // Move to the next player
            currentPlayerIndex += 1
        } else {
            // All roles are assigned, set this to true for navigation
            allRolesAssigned = true
        }

        // Reset the card state for the next player
        isFlipped = false // Reset the flip state for the next player
        backDegree = 0    // Reset back degree for the next player
        frontDegree = -90 // Reset front degree for the next player
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                Color(hex: 0xE9DFCF).ignoresSafeArea()

                if currentPlayerIndex < players.count { // Ensure index is in bounds
                    let currentPlayer = players[currentPlayerIndex]

                    VStack {
                        Text("Round - 1")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.semibold)
                            .padding(.top, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                        Spacer()

                        if isFlipped {
                            Text("\(currentPlayer.name), hide your card")
                                .font(.system(.title, design: .rounded))
                        } else {
                            Text("\(currentPlayer.name), flip the card")
                                .font(.system(.title, design: .rounded))
                        }

                        // Spacing for the title & button placement
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()

                        if isFlipped {
                            if currentPlayer.title.contains("Helper") {
                                // If the current player is the Helper, show the thief's name
                                if let thief = players.first(where: { $0.title.contains("Thief") }) {
                                    Text("\(currentPlayer.title)\nThe Thief is: \(thief.name)")
                                        .font(.title)
                                        .multilineTextAlignment(.center)
                                } else {
                                    Text(currentPlayer.title)
                                        .font(.title)
                                }
                            } else if currentPlayer.title.contains("Thief") {
                                    // If the current player is the Thief, show the item stolen
                                    Text("\(currentPlayer.title)\nItem stolen: \(selectedItem.name)")
                                        .font(.title)
                                        .multilineTextAlignment(.center)
                                } else {
                                    Text(currentPlayer.title) // Show title of the card
                                        .font(.title)
                                }
                        }

                        Spacer()

                        Button(action: {
                            nextPlayer()
                        }) {
                            Text("Continue")
                                .frame(width: 240, height: 45)
                                .background(Color(hex: 0x6B4F44))
                                .foregroundStyle(.white)
                                .cornerRadius(10)
                        }

                        Spacer()
                    }
                    .foregroundStyle(Color(hex: 0x6B4F44))
                    // End of VStack

                    // Call the card front view
                    CardFront(width: width, height: height, imageName: currentPlayer.cardImage, degree: $frontDegree)
                    // Call the card back view
                    CardBack(width: width, height: height, degree: $backDegree)
                    // NavigationDestination to RiddlePage, passing selectedItem
                        .navigationDestination(isPresented: $allRolesAssigned) {
                            RiddlePage(
                                playerRole: mostVotedPlayerRole, selectedItem: selectedItem // Pass playerRole here
                            )
                        }
                }
            }
            .onTapGesture {
                flipCard()
            }
        }.navigationBarBackButtonHidden(true)
    }
}



// Game view to start the player role cards
struct GameView: View {
    var gameData: (players: [Player], selectedItem: Item)?
    
    init(playerNames: [String]) {
        self.gameData = createPlayers(playerNames: playerNames)
    }
    
    var body: some View {
        if let gameData = gameData {
            PlayerRoleCard(players: gameData.players, selectedItem: gameData.selectedItem)
        } else {
            Text("Error creating game data")
                .foregroundColor(.red)
        }
    }
}

#Preview {
    GameView(playerNames: ["Player 1", "Player 2", "Player 3", "Player 4"])
}

//// Preview
//struct GameView_Previews: PreviewProvider {
//    static var previews: some View {
//        GameView()
//    }
//}
