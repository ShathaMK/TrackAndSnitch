//
//  ContentView.swift
//  FirstChallenge
//
//  Created by Yomna Eisa on 30/09/2024.
//

import SwiftUI

class PlayersData: ObservableObject {
    @Published var playersNames: [String] = []
}

struct playersView: View {

    
    //@State var playersNames: [String] = [] // list that will store players names
    @StateObject var playersData = PlayersData()

    @State var newPlayerName = "" //variavle used to add players
    @FocusState var isTextFieldFocused: Bool  //state used to keep foucs on input field
    @State var scrollToBottom: Bool = false // State to track scrolling
    @State var editingIndex: Int? = nil // Track which player is being edited


    //setting minimum and maximum players
    let minPlayers = 4
    let maxPlayers = 10
    
    // list of colors used
    //   brown 0x6B4E45
    //   red 0xA32B38
    //   orange 0xD16B9
    //   green 0x8DAD73
    
    // constant list of colors to cycle through
    let iconColors = [Color(hex: 0x6B4E45), Color(hex: 0xA32B38), Color(hex: 0xD16B59), Color(hex: 0x8DAD73)]
    
    // function to add player's names into the list
    func addPlayer() {
        if !newPlayerName.isEmpty && playersData.playersNames.count < maxPlayers {
            playersData.playersNames.append(newPlayerName)
            newPlayerName = "" // Clear input field
            
            // After adding a player, keep the input field focused
                        isTextFieldFocused = true
            
            // Trigger scrolling after adding a new player
            scrollToBottom = true
            
        } // end of if
    } // end of func
    
//    
//    func deletePlayer(at index: Int) {
//        playersNames.remove(at: index)
//        if editingIndex == index {
//            newPlayerName = ""  // Clear the input field if the edited player was deleted
//            editingIndex = nil  // Reset editing state
//        } else if let editingIndex = editingIndex, editingIndex > index {
//            self.editingIndex = editingIndex - 1
//        }
//    }

    
    
    // function to loop through the theme colors for the player's icons
    func colorForPlayer(at index: Int) -> Color {
        return iconColors[index % iconColors.count] // Cycle through colors using modulo
    }
    
    
    var body: some View {
        NavigationView {
            ZStack{
                //Background for page
                Image("bgpaper").resizable().scaledToFill().ignoresSafeArea()
                
                VStack { // Vstack 2 that has the list of players
                    
                    // this button bring the user back to the page before it
                    Button(action: {}) {
                        Image(systemName: "arrowshape.left")
                            .frame(width: 30, height: 30)
                            .background(Color(hex: 0x6B4E45))
                            .foregroundColor(.white) // White text
                            .cornerRadius(10) // Rounded corners
                        .padding(.trailing, 290)                }
                    
                    //titles
                    Text("Add Your Player").font(.largeTitle).bold().foregroundColor(Color(hex: 0x6B4E45)).padding(.top, 10)
                    
                    Text("The Players Are...").font(.title2).foregroundColor(Color(hex: 0x6B4E45)).bold()
                    
                    
                    // Notify if max players are reached
                    if playersData.playersNames.count >= maxPlayers {
                        Text("Maximum number of players reached!").bold()
                            .foregroundColor(.red) // Red text for visibility
                    }
                    
                    ScrollViewReader { proxy in // Move proxy into the ScrollViewReader
                        List{ // list that contains a loop of the players to display their names
                            ForEach(playersData.playersNames.indices, id: \.self){ index in
                                HStack { // HStack to displayer user info with edit and delete horizontally
                                    
                                    //player icon with one of the theme colors
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .padding(10)
                                        .foregroundColor(colorForPlayer(at: index))
                                    
                                    // player's name
                                    Text(playersData.playersNames[index])
                                        .foregroundColor(Color(hex: 0x6B4E45))
                                        .bold()
                                    
                                    Spacer()
                                    
                                    // Delete Button
                                    Button(action: {
                                        playersData.playersNames.remove(at: index)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                            .padding()
                                    }
                                    
                                    //  }
                                }// end of HStack
                                .listRowBackground(Color(hex: 0xFCF4E8)) // change list's row color
                                .id(index) // Unique id for each row for auto scrolling
                            } // end of for each
                            
                        } // End of List
                        .cornerRadius(5)
                        .scrollContentBackground(.hidden)
                        .onChange(of: playersData.playersNames.count) { newCount in
                            // Scroll to the last player added after they are added
                            if scrollToBottom {
                                withAnimation {
                                    proxy.scrollTo(newCount - 1, anchor: .bottom)
                                } //end of withAnimation
                            } // end of scrollToBottom
                        } // end of on change
                    } // End of ScrollViewReader
                    
                    
                    
                    HStack{ //HStack that contains the inputfield,
                        if playersData.playersNames.count < maxPlayers {
                            TextField("Enter player name", text: $newPlayerName).textFieldStyle(RoundedBorderTextFieldStyle()).autocorrectionDisabled().frame(width: 300, height: 100).onSubmit {
                                addPlayer()
                            }
                            .disabled(playersData.playersNames.count >= maxPlayers)
                            .foregroundColor((playersData.playersNames.count < maxPlayers) ? Color(hex: 0x6B4E45) : Color.gray).padding(.leading).focused($isTextFieldFocused)
                            .onAppear {
                                isTextFieldFocused = true // Keep focus when view appears
                            }
                            
                            Button(action: {
                                addPlayer()
                            }){
                                Image(systemName: "plus.app.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(!newPlayerName.isEmpty && playersData.playersNames.count < maxPlayers ? Color(hex: 0x6B4E45) : Color.gray) // Button color based on state
                            }
                            
                        }// end of if
                        
                        
                    } // End of HStack that has the input field and button
                    
             /*       Button(action: {}) {
                        Text("Start")
                            .frame(width: 200, height: 40)
                            .background(playersData.playersNames.count >= minPlayers ? Color(hex: 0x6B4E45) : Color.gray) // Brown if enough players, otherwise gray
                            .foregroundColor(.white) // White text
                            .cornerRadius(10) // Rounded corners
                            .overlay( // Adding the border on top
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(playersData.playersNames.count >= minPlayers ? Color(hex: 0x6B4E45) : Color.gray, lineWidth: 2) // Brown border
                            )
                    }.disabled(playersData.playersNames.count < minPlayers) // Disable until min players reached */
                    
                    // Start button using NavigationLink to navigate to VotingView
                    
                    NavigationLink(
                        destination: GameView(playerNames: playersData.playersNames).navigationBarBackButtonHidden(true),
                        label: {
                            Text("Start")
                                .frame(width: 200, height: 40)
                                .background(playersData.playersNames.count >= minPlayers ? Color(hex: 0x6B4E45) : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(playersData.playersNames.count >= minPlayers ? Color(hex: 0x6B4E45) : Color.gray, lineWidth: 2)
                                )
                        }
                    )
                    .disabled(playersData.playersNames.count < 4)
                    .padding()

                    
                }// end of VStack 2
            }//end zstack
        } // end of NavigationView 
    } // end of body
} // end of playersView



#Preview {
    playersView()
}


/*
extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
} */


struct playerNameKey: EnvironmentKey {
    static let defaultValue: PlayersData = PlayersData()
}

extension EnvironmentValues {
    var playersData: PlayersData {
        get { self[playerNameKey.self] }
        set { self[playerNameKey.self] = newValue }
    }
}
