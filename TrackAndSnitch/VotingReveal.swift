import SwiftUI

struct VotingReveal: View {
    // constant list of colors to cycle through
    let iconColors = [Color(hex: 0x6B4E45), Color(hex: 0xA32B38), Color(hex: 0xD16B59), Color(hex: 0x8DAD73)]
    
    // Data passed from the previous voting page
    let playersVotes: [(name: String, votes: Int)] // List of players and their vote counts
    
    // Determine the player with the most votes
    var mostVotedPlayer: (name: String, votes: Int)? {
        playersVotes.max(by: { $0.votes < $1.votes })
    }
    
    var maxVotes: Int {
        playersVotes.map { $0.votes }.max() ?? 1
    }
    
    // function to loop through the theme colors for the player's icons
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
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: 0x6B4E45))
                
                Text("and the most voted player(s) is...")
                    .font(.title2)
                    .foregroundColor(Color(hex: 0x6B4E45))
                    .bold()
                
                // Display the vote counts for each player
                List {
                    ForEach(Array(playersVotes.enumerated()), id: \.element.name) { index, player in
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
                        .padding(.vertical, 10)
                    }
                    .listRowBackground(Color(hex: 0xFCF4E8)) // Change list's row color
                }
                .scrollContentBackground(.hidden) // Hide background of the list
                
                Spacer()
                
                // Continue Button
                Button(action: { print("Continue to the next page") }) {
                    Text("Continue")
                        .font(.title2)
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
        // Sample data for preview
        VotingReveal(playersVotes: [("Player 1", 2), ("Player 2", 1), ("Player 3", 3), ("Player 4", 1), ("Player 5", 3), ("Player 6", 1), ("Player 7", 3), ("Player 8", 3), ("Player 9", 3), ("Player 10", 3)])
    }
}

#Preview {
    VotingReveal(playersVotes: [])
}
