//
//  ContentView.swift
//  FirstChallenge
//
//  Created by Yomna Eisa on 30/09/2024.
//

import SwiftUI

// Define a helper function to generate colors from hex values
struct ColorHelper {
    static func colorFromHex(_ hex: UInt, alpha: Double = 1.0) -> Color {
        return Color(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

// List of colors used
let iconColors: [Color] = [
    ColorHelper.colorFromHex(0x6B4E45), // Brown
    ColorHelper.colorFromHex(0xA32B38), // Red
    ColorHelper.colorFromHex(0xD16B59), // Orange
    ColorHelper.colorFromHex(0x8DAD73)  // Green
]

class PlayersData: ObservableObject {
    @Published var playersNames: [String] = [] // Players names
//    @Published var playerVotes: [Int] = [] // Votes corresponding to players
//        @Published var itemVotes: [Int] = [] // Votes corresponding to items
}

struct playersView: View {

    @StateObject var playersData = PlayersData()

    @State var newPlayerName = "" // Variable used to add players
    @FocusState var isTextFieldFocused: Bool  // State used to keep focus on input field
    @State var scrollToBottom: Bool = false // State to track scrolling
    @State var editingIndex: Int? = nil // Track which player is being edited
    @State var showPlayerWarning = false // State to manage the pop-up visibility

    // Setting minimum and maximum players
    let minPlayers = 4
    let maxPlayers = 10
    
    // Function to add player's names into the list
    func addPlayer() {
        if !newPlayerName.isEmpty && playersData.playersNames.count < maxPlayers {
            playersData.playersNames.append(newPlayerName)
            newPlayerName = "" // Clear input field
            isTextFieldFocused = true
            scrollToBottom = true
        }
    }
    
    // Function to loop through the theme colors for the player's icons
    func colorForPlayer(at index: Int) -> Color {
        return iconColors[index % iconColors.count] // Cycle through colors using modulo
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background for page
                Image("bgpaper").resizable().scaledToFill().ignoresSafeArea()
                
                VStack {
                    // Updated Exit Button to navigate to ContentView
                    NavigationLink(destination: ContentView()) {
                        Image(systemName: "arrowshape.left")
                            .frame(width: 30, height: 30)
                            .background(ColorHelper.colorFromHex(0x6B4E45))
                            .foregroundColor(.white) // White text
                            .cornerRadius(10) // Rounded corners
                            .padding(.trailing, 290)
                    }
                    
                    // Titles
                    Text("Add Your Player")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(ColorHelper.colorFromHex(0x6B4E45))
                        .padding(.top, 10)
                    
                    Text("The Players Are...")
                        .font(.title2)
                        .foregroundColor(ColorHelper.colorFromHex(0x6B4E45))
                        .bold()
                    
                    // Notify if max players are reached
                    if playersData.playersNames.count >= maxPlayers {
                        Text("Maximum number of players reached!").bold()
                            .foregroundColor(.red) // Red text for visibility
                    }
                    
                    ScrollViewReader { proxy in
                        List {
                            ForEach(playersData.playersNames.indices, id: \.self) { index in
                                HStack {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .padding(10)
                                        .foregroundColor(colorForPlayer(at: index))
                                    
                                    Text(playersData.playersNames[index])
                                        .foregroundColor(ColorHelper.colorFromHex(0x6B4E45))
                                        .bold()
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        playersData.playersNames.remove(at: index)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                            .padding()
                                    }
                                }
                                .listRowBackground(ColorHelper.colorFromHex(0xFCF4E8)) // Change list's row color
                                .id(index) // Unique id for each row for auto scrolling
                            }
                        }
                        .cornerRadius(5)
                        .scrollContentBackground(.hidden)
                        .onChange(of: playersData.playersNames.count) { newCount in
                            if scrollToBottom {
                                withAnimation {
                                    proxy.scrollTo(newCount - 1, anchor: .bottom)
                                }
                            }
                        }
                    }
                    
                    HStack {
                        if playersData.playersNames.count < maxPlayers {
                            TextField("Enter player name", text: $newPlayerName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocorrectionDisabled()
                                .frame(width: 300, height: 100)
                                .onSubmit {
                                    addPlayer()
                                }
                                .disabled(playersData.playersNames.count >= maxPlayers)
                                .foregroundColor(playersData.playersNames.count < maxPlayers ? ColorHelper.colorFromHex(0x6B4E45) : Color.gray)
                                .padding(.leading)
                                .focused($isTextFieldFocused)
                                .onAppear {
                                    isTextFieldFocused = true // Keep focus when view appears
                                }
                            
                            Button(action: {
                                addPlayer()
                            }) {
                                Image(systemName: "plus.app.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(!newPlayerName.isEmpty && playersData.playersNames.count < maxPlayers ? ColorHelper.colorFromHex(0x6B4E45) : Color.gray) // Button color based on state
                            }
                        }
                    }
                    
                    Button(action: {
                        // Show the pop-up if the player count is less than the minimum required
                        if playersData.playersNames.count < minPlayers {
                            showPlayerWarning = true
                        } else {
                            // Proceed to the game if enough players are present
                            showPlayerWarning = false
                        }
                    }) {
                        Text("Start")
                            .frame(width: 200, height: 40)
                            .background(ColorHelper.colorFromHex(0x6B4E45)) // Always clickable
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(ColorHelper.colorFromHex(0x6B4E45), lineWidth: 2)
                            )
                    }
                    .padding()
                }
                
                // Fun pop-up message for player count warning
                if showPlayerWarning {
                    ZStack {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                        
                        VStack(spacing: 20) {
                            // Place the X button in the top-left corner of the pop-up
                            HStack {
                                Button(action: {
                                    showPlayerWarning = false // Close the pop-up
                                }) {
                                    Text("X")
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .frame(width: 40, height: 40)
                                        .background(Color.red)
                                        .clipShape(Circle())
                                }
                                Spacer()
                            }
                            .padding(.top)
                            .padding(.leading)
                            
                            Spacer()
                            
                            Text("Oops!")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                            
                            Text("You need at least \(minPlayers) players to start the game!")
                                .font(.title3)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        .padding()
                        .background(ColorHelper.colorFromHex(0x6B4E45))
                        .cornerRadius(20)
                        .frame(width: 300, height: 300)
                        .shadow(radius: 10)
                    }
                    .transition(.opacity)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    playersView()
}
