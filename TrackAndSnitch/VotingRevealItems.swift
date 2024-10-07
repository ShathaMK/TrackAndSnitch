import SwiftUI

struct VotingRevealItems: View {
    // Constant list of colors to cycle through
    let iconColors = [Color(hex: 0xA32B38), Color(hex: 0xD16B59), Color(hex: 0x8DAD73)]
    
    // Data passed from the previous voting page
    let itemsVotes: [(item: String, votes: Int)] // List of items and their vote counts
    
    // Determine the item with the most votes
    var mostVotedItem: (item: String, votes: Int)? {
        itemsVotes.max(by: { $0.votes < $1.votes })
    }
    
    var maxVotes: Int {
        itemsVotes.map { $0.votes }.max() ?? 1
    }
    
    // Function to loop through the theme colors for the items' bars
    func colorForItem(at index: Int) -> Color {
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
                
                Text("and the most voted item(s) is...")
                    .font(.title2)
                    .foregroundColor(Color(hex: 0x6B4E45))
                    .bold()
                
                // Display the vote counts for each item
                List {
                    ForEach(Array(itemsVotes.enumerated()), id: \.element.item) { index, item in
                        HStack {
                            // Item's name
                            Text(item.item)
                                .font(.system(size: 20, weight: .semibold))
                                .frame(width: 100, alignment: .leading)
                                .foregroundColor(Color(hex: 0x6B4E45))
                            
                            Spacer()
                            
                            // Bar representing the vote count
                            GeometryReader { geometry in
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(colorForItem(at: index)) // Use theme colors for the bars
                                    .frame(width: geometry.size.width * CGFloat(item.votes) / CGFloat(maxVotes), height: 30)
                            }
                            .frame(height: 30) // Height of the bar
                            
                            // Display vote count on the right side
                            Text("\(item.votes)")
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

struct VotingRevealItems_Previews: PreviewProvider {
    static var previews: some View {
        // Sample data for preview
        VotingRevealItems(itemsVotes: [("Item 1", 5), ("Item 2", 2), ("Item 3", 8)])
    }
}

#Preview {
    VotingRevealItems(itemsVotes: [])
}
