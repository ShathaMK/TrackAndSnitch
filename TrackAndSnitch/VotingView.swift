import SwiftUI

struct VotingView: View {
    
    @ObservedObject var playersData: PlayersData  // Receive the data from ContentView
    @State private var playersVotes: [(String, Int)] = [] //to save the palyers names with their votes
    
    @State private var selectedPlayerIndex: Int? = nil // Track selected player for the vote
    @State private var votes: [Int] = Array(repeating: 0, count: 10) // Array to track votes for each player
    @State private var currentVoterIndex: Int = 0 // Track which player is voting
    @State private var votingCompleted = false // Track if voting is completed
    @State private var tiePlayers: [String] = [] // Holds the players who tied, if any
   // @State private var navigateToReveal = false  // Trigger navigation
    @State private var navigateToThiefScreen = false // Navigate if a thief wins
    @State private var navigateToTrackerScreen = false // Navigate if other role wins
    @State private var mostVotedPlayerRole: String? = nil // Store the most voted player's role



    var body: some View {
        NavigationStack {
            ZStack {
                Image("bgpaper").resizable().scaledToFill().ignoresSafeArea()
                VStack {
                    if !votingCompleted {
                        // Display current voter
                        Text("Who is the thief?")
                            .font(.title)
                            .bold()
                            .foregroundColor(Color(hex: 0x6B4E45))
                        
                        Text("\(playersData.playersNames[currentVoterIndex])'s turn to vote")
                            .font(.title3)
                            .foregroundColor(Color(hex: 0x6B4E45)).bold()
                        
                        // List of players with radio buttons for voting
                        List(playersData.playersNames.indices, id: \.self) { index in
                            HStack {
                                Image(systemName: selectedPlayerIndex == index ? "circle.circle.fill" : "circle")
                                    .foregroundColor(Color(hex: 0x6B4E45))
                                    .onTapGesture {
                                        selectedPlayerIndex = index // Set selected player for vote
                                    }
                                Text(playersData.playersNames[index])
                                    .bold()
                                    .foregroundColor(Color(hex: 0x6B4E45)).bold()
                                    .padding()
                            }
                            .listRowBackground(Color(hex: 0xFCF4E8)) // Change list's row color
                        } // end of list
                        .cornerRadius(5)
                        .scrollContentBackground(.hidden) // Hide the background color on the list
                        
                        Button(action: {
                            if let selected = selectedPlayerIndex {
                                votes[selected] += 1 // Increment the selected player's vote
                            }
                            
                            if currentVoterIndex >= playersData.playersNames.count - 1 {
                                votingCompleted = true // Mark voting as completed
                                showResults() // Calculate the most voted player
                            } else {
                                currentVoterIndex += 1 // Move to the next voter
                                selectedPlayerIndex = nil // Reset selection for the next voter
                            }
                        }) {
                            Text(currentVoterIndex >= playersData.playersNames.count - 1 ? "Catch the thief!" : "Continue")
                                .padding()
                                .background(selectedPlayerIndex != nil ? Color(hex: 0x6B4E45) : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(selectedPlayerIndex == nil) // Disable button if no selection
                    } //else {
                   
                    //THIS IS WORKING BUT WE NEED TO PASS THR ROLES AS WELL
                    // Navigate to the VotingReveal view when voting is completed
                   /* NavigationLink(
                        destination: VotingReveal(playersData: playersData, playersVotes: playersVotes).navigationBarBackButtonHidden(true), isActive: .constant(votingCompleted)
                    ) {
                        EmptyView()
                    }*/
                    
                    NavigationLink(
                        destination: VotingReveal(playersData: playersData, playersVotes: playersVotes, mostVotedPlayerRole: mostVotedPlayerRole ?? "").navigationBarBackButtonHidden(true),
                        isActive: .constant(votingCompleted)
                    ) {
                        EmptyView()
                    }

                    
                    // Navigate based on the role of the player with most votes
                     /*
                    NavigationLink(
                        destination: WinnersView(), // Screen to navigate if the thief wins
                             isActive: $navigateToThiefScreen
                         ) {
                             EmptyView()
                         }
                         
                         NavigationLink(
                             destination: WinnersView(), // Screen to navigate if non-thief wins
                             isActive: $navigateToTrackerScreen // edit the destination here later
                         ) {
                             EmptyView()
                         }*/
                    
                    // If voting is completed, navigate to results
                    /*    NavigationLink(destination: VotingItemsView(playersData: playersData).navigationBarBackButtonHidden(true), isActive: .constant(votingCompleted)) {
                            EmptyView() // This is required to make NavigationLink work with isActive
                        } // end of nav link */
                   // } // end of else
                    
                } // end of VStack
                .padding()
            } // end of ZStack
        } // end of NavigationStack
    } // end of body

    func showResults() {
        // Combine player names and votes into an array of tuples
        playersVotes = zip(playersData.playersNames, votes).map { ($0, $1) }

        // Find the player with the most votes
        let maxVotes = votes.max() ?? 0
        let mostVotedPlayerIndex = votes.firstIndex(of: maxVotes) ?? 0
        let mostVotedPlayer = playersData.playersNames[mostVotedPlayerIndex]
        
        // Retrieve role of the most voted player
        let playerRoles = PlayerRoleStorage.shared.getRoles() // Retrieve saved roles
        let roleOfMostVotedPlayer = playerRoles.first { $0.0 == mostVotedPlayer }?.1
        
        // Retrieve the role of the most voted player
        mostVotedPlayerRole = playerRoles.first { $0.0 == mostVotedPlayer }?.1

        // Navigate based on the role
        if roleOfMostVotedPlayer == "Thief" {
            navigateToThiefScreen = true
        } else {
            navigateToTrackerScreen = true
        }
        
    } // end of function
}

struct VotingView_Previews: PreviewProvider {
    static var previews: some View {
        let samplePlayersData = PlayersData()
        samplePlayersData.playersNames = ["Player 1", "Player 2", "Player 3", "Player 4"] // Sample data
        
        return VotingView(playersData: samplePlayersData) // Provide the playersData argument
    }
}


