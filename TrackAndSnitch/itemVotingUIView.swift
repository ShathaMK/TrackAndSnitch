import SwiftUI

struct VotingItemsView: View {
    @ObservedObject var playersData = PlayersData.shared // Access the singleton
    let selectedItem: Item // Receive the selected item

    @State var currentVoterIndex: Int = 0 // Track which player is voting
    @State var selectedItemIndex: Int? = nil // Track selected item
    @State var items: [String] = [] // List of voting items
    @State var correctAnswer: String = "" // Non-optional
    @State var votes: [String: String] = [:] // Dictionary to store votes (player -> item)
    @State var votingCompleted = false // Track if voting is completed
    @State var csvDataLoaded = false // Track if the CSV has been loaded
    @State private var showVotingCompleteAlert = false // For showing alert after voting
    @State var navigateToItemReveal = false  // For navigation to ItemVoteReveal view


    var body: some View {
NavigationView {
        ZStack {
            Image("bgpaper")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack {
                if csvDataLoaded {
                    if !votingCompleted {
                        if currentVoterIndex < playersData.playersNames.count {
                            Text("What is the stolen item?")
                                .font(.title)
                                .bold()
                                .foregroundColor(Color(hex: 0x6B4E45))
                            
                            Text("\(playersData.playersNames[currentVoterIndex])'s turn to vote")
                                .font(.title3)
                                .foregroundColor(Color(hex: 0x6B4E45))
                                .bold()
                                .padding(.bottom)
                            
                            // List of items with radio buttons for voting
                            List(items.indices, id: \.self) { index in
                                HStack {
                                    Image(systemName: selectedItemIndex == index ? "circle.circle.fill" : "circle")
                                        .foregroundColor(Color(hex: 0x6B4E45))
                                        .onTapGesture {
                                            selectedItemIndex = index // Set selected item for vote
                                        }
                                    Text(items[index])
                                        .bold()
                                        .foregroundColor(Color(hex: 0x6B4E45))
                                        .padding()
                                }
                                .listRowBackground(Color(hex: 0xFCF4E8)) // Change list's row color
                                .padding(20)
                            }
                            .cornerRadius(5)
                            .scrollContentBackground(.hidden) // Hide the background color on the list
                            
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
                                        showVotingCompleteAlert = true // Show alert upon completion
                                    }
                                }
                            }) {
                                Text(currentVoterIndex >= playersData.playersNames.count - 1 ? "Reveal Votes!" : "Continue")
                                    .padding()
                                    .background(selectedItemIndex != nil ? Color(hex: 0x6B4E45) : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .disabled(selectedItemIndex == nil)  // Disable until an item is selected
                            .padding(.horizontal, 20)
                           /* .alert(isPresented: $showVotingCompleteAlert) {
                                Alert(
                                    title: Text("Voting Completed"),
                                    message: Text("All players have voted."),
                                    dismissButton: .default(Text("OK"))
                                )
                            }*/
                        } else {
                            // Handle out-of-range access
                            Text("Error: No player available for voting.")
                                .foregroundColor(.red)
                        }
                    } /*else {
                       // Optional: Additional UI when voting is completed
                       Text("Voting Completed!")
                       .font(.title)
                       .padding()
                       }*/
                } else {
                    Text("Loading voting items...")
                }
            }
            .onAppear {
                // Debugging: Log current state
                print("VotingItemsView appeared. playersNames: \(playersData.playersNames), currentVoterIndex: \(currentVoterIndex)")
                loadItemsFromCSV()
                
                // Ensure playersNames is populated
                if playersData.playersNames.isEmpty {
                    playersData.playersNames = PlayerRoleStorage.shared.getRoles().map { $0.0 }
                    print("playersData.playersNames was empty. Initialized with: \(playersData.playersNames)")
                }
            }
            .padding()
            NavigationLink(destination: VotingRevealItems(
                itemsVotes: calculateItemVotes(votes: votes)).navigationBarBackButtonHidden(true),
                           isActive: $navigateToItemReveal) {
                EmptyView() // This ensures we only navigate when the button triggers it
            }
        } // End of ZStack
    } // end of nav view
    } // End of body

    // Function to calculate item votes
    func calculateItemVotes(votes: [String: String]) -> [(item: String, votes: Int)] {
        var itemVoteCount: [String: Int] = [:]
        
        // Count the votes for each item
        for (_, item) in votes {
            itemVoteCount[item, default: 0] += 1
        }
        
        // Ensure all items are included even if they have zero votes
        for item in items {
            _ = itemVoteCount[item, default: 0] // Accessing it to ensure it's counted
        }

        // Convert the dictionary into an array of tuples
        return itemVoteCount.map { (item: $0.key, votes: $0.value) }
    }

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
                    if wrongItems.count >= 2 {
                        items = ([correct] + wrongItems.prefix(2)).shuffled()
                    } else {
                        // Handle cases where there are fewer than 2 wrong items
                        items = ([correct] + wrongItems).shuffled()
                    }
                    csvDataLoaded = true  // Indicate that data is ready
                }
            } catch {
                print("Error reading the CSV file: \(error)")
            }
        } else {
            print("CSV file not found")
        }
    } // end of function

}

struct VotingItemsView_Previews: PreviewProvider {
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
        // Populate PlayersData.shared.playersNames
        PlayersData.shared.playersNames = PlayerRoleStorage.shared.getRoles().map { $0.0 }
        return VotingItemsView(selectedItem: sampleItem)
    }
}
