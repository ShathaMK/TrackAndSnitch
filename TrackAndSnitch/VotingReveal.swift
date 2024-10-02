//
//  VotingReveal.swift
//  TrackAndSnitch
//
//  Created by Raghad Mohammed Almarri on 29/03/1446 AH.
//
//



import SwiftUI


struct VotingReveal: View {
    // Data passed from the previous voting page
    let playersVotes: [(name: String, votes: Int)] // List of players and their vote counts
    
    // Determine the player with the most votes
    var mostVotedPlayer: (name: String, votes: Int)? {
        playersVotes.max(by: { $0.votes < $1.votes })
    }
    
    var body: some View {
        ZStack{
            Image("bg paper")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Title
                Text("Vote Reveal")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red:0.46, green:0.133,blue:0.047))
                
                Text("and the most voted player is...")
                    .font(.system(size: 27))
                    .foregroundColor(Color(red:0.46, green:0.133,blue:0.047))
                    .padding(.bottom, 46)
                
                // Display the vote counts for each player
                VStack(spacing: 15) {
                    ForEach(playersVotes, id: \.name) { player in
                        HStack {
                            Text(player.name)
                                .font(.system(size: 27, weight: .semibold))
                                .foregroundColor(Color(red:0.46 , green:0.133,blue:0.047))
                                .frame(width: 100, alignment: .leading)
                            Spacer()
                            Text("\(player.votes)")
                                .font(.body)
                                .padding(8)
                                .background(player.votes == mostVotedPlayer?.votes ? Color(red:0.46, green:0.133,blue:0.047) : Color(red:0.82, green:0.59,blue:0.56))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 50)
                    }
                }
                
                // Show the name of the player with the most votes
                if let winner = mostVotedPlayer {
                    Text(winner.name)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red:0.99 ,green:0.98,blue:0.90))
                        .padding(.top, 80)
                } else {
                    
                    Text("No votes")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .padding(.top, 80)
                }
                
                Spacer()
                
                // Continue Button
                Button(action: {print("Continue to the next page")}) { //curly braket for Button
                    Text("Continue")
                        .font(.title2)
                        .padding()
                        .background(Color(red:0.55 ,green:0.67,blue:0.45))
                        .cornerRadius(10)
                        .foregroundColor(Color(red:0.99 ,green:0.98,blue:0.90))
                }
                .padding()
                Spacer()

            }
        }
        
        
    }
    
    
    struct VotingReveal_Previews: PreviewProvider {
        static var previews: some View {
            // Sample data for preview
            VotingReveal(playersVotes: [("Player 1", 0), ("Player 2", 0), ("Player 3",0 )])
        }
    }
}

#Preview {
    VotingReveal(playersVotes:[])
}
