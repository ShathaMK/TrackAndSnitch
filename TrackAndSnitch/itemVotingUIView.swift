import SwiftUI

struct VotingItemsView: View {
    @ObservedObject var playersData: PlayersData  // List of players from ContentView
    @State var currentVoterIndex: Int = 0 // Track which player is voting
    @State var selectedItemIndex: Int? = nil      // Track selected item
    @State var items: [String] = []               // List of voting items
    @State var correctAnswer: String? = nil       // Correct answer
    @State var votes: [String: String] = [:]      // Dictionary to store votes (player -> item)
    @State var votingCompleted = false            // Track if voting is completed
    @State var csvDataLoaded = false              // Track if the CSV has been loaded
    
    var body: some View {
NavigationView {
        ZStack{
            Image("bgpaper").resizable().scaledToFill().ignoresSafeArea()
            VStack{
                if csvDataLoaded {
                    if !votingCompleted {
                        
                        Text("What is the stolen item?")
                            .font(.title)
                            .bold()
                            .foregroundColor(Color(hex: 0x6B4E45))
                        
                        Text("\(playersData.playersNames[currentVoterIndex])'s turn to vote")
                            .font(.title3)
                            .foregroundColor(Color(hex: 0x6B4E45)).bold().padding(.bottom)
                        
                        // List of players with radio buttons for voting
                        List(items.indices, id: \.self) { index in
                            HStack {
                                Image(systemName: selectedItemIndex == index ? "circle.circle.fill" : "circle")
                                    .foregroundColor(Color(hex: 0x6B4E45))
                                    .onTapGesture {
                                        selectedItemIndex = index // Set selected player for vote
                                    }
                                Text(items[index])
                                    .bold()
                                    .foregroundColor(Color(hex: 0x6B4E45)).bold()
                                    .padding()
                            }.listRowBackground(Color(hex: 0xFCF4E8)) // change list's row color
                                .padding(20) // end of HStack
                        }
                        .cornerRadius(5)
                        .scrollContentBackground(.hidden) // hide the background color on the list
                        
                        
                        Button(action: {
                            if let selectedItemIndex = selectedItemIndex {
                                let selectedVote = items[selectedItemIndex]
                                let currentPlayer = playersData.playersNames[currentVoterIndex]
                                
                                // Save the current player's vote
                                votes[currentPlayer] = selectedVote
                                
                                // Move to the next player or complete voting
                                if currentVoterIndex < playersData.playersNames.count - 1 {
                                    currentVoterIndex += 1
                                    self.selectedItemIndex = nil  // Reset selection for next player
                                } else {
                                    votingCompleted = true  // All players have voted
                                }
                            } // end of if
                        }) {
                            Text(currentVoterIndex >= playersData.playersNames.count - 1 ? "Reveal Votes!" : "Continue")
                                .padding()
                                .background(selectedItemIndex != nil ? Color(hex: 0x6B4E45) : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(selectedItemIndex == nil)  // Disable until an item is selected
                        // end of button
                    } else {
                        Text("Voting completed!")
                            .font(.title)
                            .padding()
                        
                        // Show the voting results
                        Text("Results:")
                            .font(.headline)
                            .padding(.top)
                        
                        ForEach(playersData.playersNames, id: \.self) { player in
                            if let vote = votes[player] {
                                Text("\(player) voted for: \(vote)")
                            }
                        }
                        
                        Text("Correct answer: \(correctAnswer ?? "")")
                            .font(.headline)
                            .padding(.top)
                    } // end of if else
                } else {
                    Text("Loading voting items...")
                } // end of it and else
            }
            .onAppear {
                loadItemsFromCSV()
            }
            .padding()
        } // end of ZStack
        
    } // end of nav view
    
    } // end of body
    
    
    // Function to load items from the CSV file
    func loadItemsFromCSV() {
        // Specify the path to the CSV file
        let fileName = "db7"
        if let path = Bundle.main.path(forResource: fileName, ofType: "csv") {
            do {
                let csvContent = try String(contentsOfFile: path)
                let csvLines = csvContent.components(separatedBy: "\n")
                
                // Initialize an array to hold items
                var allItems: [String] = []
                
                // Iterate through the lines, skipping the first row (header)
                for (index, line) in csvLines.enumerated() {
                    if index == 0 { continue }  // Skip the first row (header)
                    
                    let columns = line.components(separatedBy: ",")
                    
                    // Check if there's at least one column and add the first column's data
                    if columns.count > 0 {
                        let item = columns[0].trimmingCharacters(in: .whitespacesAndNewlines)  // Get the first column and trim whitespace
                        
                        // Only add non-empty items
                        if !item.isEmpty {
                            allItems.append(item)   // Add the first column's data to the items array
                        }
                    }
                }
                
                // Pick one correct answer and two wrong items
                if let correct = allItems.randomElement() {
                    correctAnswer = correct
                    var wrongItems = allItems.filter { $0 != correct }
                    wrongItems.shuffle()
                    
                    // Combine the correct answer with two wrong ones
                    items = ([correct] + wrongItems.prefix(2)).shuffled()
                    csvDataLoaded = true  // Indicate that data is ready
                }
            } catch {
                print("Error reading the CSV file: \(error)")
            }
        } else {
            print("CSV file not found")
        }
    } // end of function

    
} // end of VotingItemsView


struct VotingItemsView_Previews: PreviewProvider {
    static var previews: some View {
        let samplePlayersData = PlayersData()
        samplePlayersData.playersNames = ["Player 1", "Player 2", "Player 3"]
        return VotingItemsView(playersData: samplePlayersData)
    }
}



