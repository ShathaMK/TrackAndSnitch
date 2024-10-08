import SwiftUI

struct VotingReveal: View {
    
    @ObservedObject var playersData: PlayersData // Access the shared PlayersData
    let playersVotes: [(name: String, votes: Int)] // List of players and their vote counts

    // Constant list of colors to cycle through
    let iconColors = [Color(hex: 0x6B4E45), Color(hex: 0xA32B38), Color(hex: 0xD16B59), Color(hex: 0x8DAD73)]
    
    // Data passed from the previous voting page
   // let playersVotes: [(name: String, votes: Int)] // List of players and their vote counts
    
    // Determine the player with the most votes
    var mostVotedPlayer: (name: String, votes: Int)? {
        playersVotes.max(by: { $0.votes < $1.votes })
    }
    
    var maxVotes: Int {
        playersVotes.map { $0.votes }.max() ?? 1
    }
    
    // Function to loop through the theme colors for the player's icons
    func colorForPlayer(at index: Int) -> Color {
        return iconColors[index % iconColors.count] // Cycle through colors using modulo
    }
    
    var body: some View {
        ZStack {
            Image("bgpaper")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 5) {
                // Title
                Text("Vote Reveal")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: 0x6B4E45))
                    .padding(.top, 20)
                
                Text("and the most voted player(s) is...")
                    .font(.title3)
                    .foregroundColor(Color(hex: 0x6B4E45))
                    .bold()
                
                // Display the vote counts for each player
                List {
                    ForEach(playersVotes.indices, id: \.self) { index in
                        let player = playersVotes[index]
                        HStack {
                            // Player's name
                            Text(player.name)
                                .font(.system(size: 20, weight: .semibold))
                                .frame(width: 100, alignment: .leading)
                                .foregroundColor(Color(hex: 0x6B4E45))
                            
                            Spacer()
                            
                            // Bar representing the vote count
                            GeometryReader { geometry in
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(colorForPlayer(at: index)) // Use theme colors for the bars
                                    .frame(width: geometry.size.width * CGFloat(player.votes) / CGFloat(maxVotes), height: 30)
                            }
                            .frame(height: 30) // Height of the bar
                            
                            // Display vote count on the right side
                            Text("\(player.votes)")
                                .padding(.leading, 10)
                                .foregroundColor(Color(hex: 0x6B4E45))
                                .bold()
                        }
                        .padding(.vertical, 20)
                    }
                    .listRowBackground(Color(hex: 0xFCF4E8)) // Change list's row color
                    
                }
                .scrollContentBackground(.hidden) // Hide background of the list
                .padding(.horizontal, 15)

                
                
             //   Spacer()
                
                // Continue Button
                Button(action: { print("Continue to the next page") }) {
                    Text("Continue")
                        .font(.title3)
                        .padding()
                        .background(Color(hex: 0x6B4E45))
                        .cornerRadius(10)
                }
                .padding()
                
                Spacer()
            }
        }
    }
}


struct VotingReveal_Previews: PreviewProvider {
    static var previews: some View {
        let samplePlayersData = PlayersData()
        samplePlayersData.playersNames = ["Player 1", "Player 2", "Player 3", "Player 4"] // Sample names
        
        // Sample player votes (you can customize this to test different scenarios)
        let samplePlayersVotes = [("Player 1", 2), ("Player 2", 1), ("Player 3", 3), ("Player 4", 1)]
        
        return VotingReveal(playersData: samplePlayersData, playersVotes: samplePlayersVotes)
    }
}

