//
//  RiddlePage.swift
//  TrackAndSnitch
//
//  Created by Shatha Almukhaild on 29/03/1446 AH.
//

//
//  PlayerRoleCard.swift
//  TrackAndSnitch
//
//  Created by Shatha Almukhaild on 28/03/1446 AH.
//

import SwiftUI
import AVFoundation
// struct for the card front
struct RiddleFront: View {
    // The width of the card
    let width: CGFloat
    // The height of the card
    let height: CGFloat
    // The degree of rotation for the card
    @Binding var degree: Double
    
    let riddles: [String] // Now an array of riddles
    
    var body: some View {
        ZStack {
            // Display the front card image
            Image("Rectangle")
                .resizable()
                .scaledToFill()
                .frame(width: 260, height:400)
                .shadow(color: .gray, radius: 3, x: 0, y: 2)
            
            
            if let riddle = riddles.first {
                Text(riddle)
                    .foregroundStyle(Color(hex:0x902A39))
                    .font(.system(.title3, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 90)
                
                //The radius is the shadow all around the card
                //x is the shadow on the right
                // y is the shadow on the bottom
            }
        }// end of ZStack
        .navigationBarBackButtonHidden(true)
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
        // The x and y and z repersent the diraction of the filp
    }
}

struct RiddlePage: View {
    // The degree of rotation for the back of the card
    @State var backDegree = 0.0
    // The degree of rotation for the front of the card
    @State var frontDegree = -90.0
    // A boolean that keeps track of whether the card is flipped or not
    @State var isFlipped = false
    // The width of the card
    let width : CGFloat = 200
    // The height of the card
    let height : CGFloat = 250
    // The duration and delay of the flip animation
    let durationAndDelay : CGFloat = 0.3
    // A function that flips the card by updating the degree of rotation for the front and back of the card
    // timer amount
    @State private var timeRemaining = 180
    // take the seconds and convert it to mm:ss format
    
    // Riddle data from CSV
    @State private var items: [(item: String, riddles: [String])] = []
    @State private var currentRiddles: [String] = [] // Current riddles to display    HERE
    @State private var currentRiddleIndex: Int = 0 // Index of the current riddle
    
    // State variable to control navigation
    @State private var navigateToNextPage = false
    
    func convertSecondstoTime(timeInSeconds:Int)->String{
        // to get the min out of seconds
        let minutes = timeInSeconds / 60
        // to make sure that we get 60 seconds for each min
        let seconds = timeInSeconds % 60
        // to put two zero in front of min and second and then pass the variabls in the place of i
        return String(format:"%02i:%02i",minutes,seconds)
    }
    //timer var to control it
    // every subtract 1s each second
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    // scene phase to let us know if the active or not
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    
    
    // Update the randomizeRiddle function to select 2 random riddles
    func randomizeRiddle() {
        guard !items.isEmpty else { return }
        
        let randomIndex = Int.random(in: 0..<items.count)
        let selectedItem = items[randomIndex]
        var riddles = selectedItem.riddles
        
        // Shuffle riddles and take the first two
        riddles.shuffle()
        currentRiddles = Array(riddles.prefix(2))
        currentRiddleIndex = 0 // Start from the first riddle in the selected item
    }
    
    func showNextRiddle() {
        guard currentRiddleIndex < currentRiddles.count - 1 else { return }
        currentRiddleIndex += 1
    }
    
    
    //autoconnect() makes the timer start immeditely
    func flipCard () {
        playSound()
        isFlipped = !isFlipped
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
    
    
    
    // Load CSV data into items
    func loadCSV() -> [(item: String, riddles: [String])] {
        let fileURL = Bundle.main.path(forResource: "db7", ofType: "csv")
        
        do {
            let data = try String(contentsOfFile: fileURL!, encoding: .utf8)
            var items: [(item: String, riddles: [String])] = []
            
            let lines = data.components(separatedBy: "\n")
            for i in 1..<lines.count {
                let line = lines[i]
                let components = line.components(separatedBy: ",")
                
                guard components.count > 1 else { continue }
                
                let item = components[0]
                let riddles = Array(components[1...])
                
                items.append((item: item, riddles: riddles))
            }
            return items
            
        } catch {
            print("Error loading CSV: \(error)")
            return []
        }
    }
    
    
    
    var body: some View {
        NavigationView {
            ZStack {
                // background color
                Color(hex: 0xE9DFCF).ignoresSafeArea()
                
                VStack{
                    
                    
                    
                    Text("Round - 1 ").font(.system(.title,design: .rounded)).fontWeight(.semibold).padding(.top,10).frame(maxWidth: .infinity, alignment: .leading).padding(.leading,20).padding(.bottom,30)
                    
                    Text("⏳"+convertSecondstoTime(timeInSeconds:timeRemaining))
                        .font(.title)
                        .foregroundStyle(Color(hex:0x902A39))
                    
                        .padding(.horizontal,20)
                        .padding(.vertical,5)
                        .background(Color(hex:0xFFEEB3).opacity(0.45))
                        .clipShape(Capsule()).overlay(    Capsule()
                            .stroke(Color(hex:0xE1A86C), lineWidth: 1)
                        )
                    
                    
                    
                    // spacing for the title & button placement
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    // Check if currentRiddleIndex is within bounds before accessing
                    if currentRiddleIndex < currentRiddles.count {
                        RiddleFront(width: width, height: height, degree: $frontDegree, riddles: [currentRiddles[currentRiddleIndex]])
                    }
                    
                    
                    Text("here's a riddle ").font(.system(.callout,design: .rounded)).padding(.top, 25)
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    
                    if currentRiddleIndex < currentRiddles.count - 1 {
                        Button(action: {
                            showNextRiddle() // Show the next riddle when button is tapped
                        }) {
                            Text("Next Riddle")
                                .frame(width: 260, height: 45)
                                .background(Color(hex: 0x6B4F44))
                                .foregroundStyle(.white)
                                .cornerRadius(10)
                        }
                        .padding(.bottom,40)
                    }
                    Spacer()
                    // end of VStack
                    // call the card front view
                    
                    // NavigationLink to go to the next page
//                    NavigationLink(destination: Testing(), isActive: $navigateToNextPage) {
//                        EmptyView()
//                    }
                }
                .foregroundColor(Color(hex: 0x6B4F44))
                
                CardBack(width: width, height: height, degree: $backDegree)
            }
        }
        
        .onAppear {
            items = loadCSV() // Load CSV data when the view appears
            randomizeRiddle() // Load a riddle when the view appears
        
                
        }
        .onReceive(timer) { _ in
            guard isActive else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                navigateToNextPage = true // Navigate to next page when timer reaches zero
            }
        }
        .onChange(of: scenePhase) { phase in
            isActive = phase == .active
        }
        .onTapGesture {
            flipCard()
        }
    }
}


#Preview {
    RiddlePage()
}


