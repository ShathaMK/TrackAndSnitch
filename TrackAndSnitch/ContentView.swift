//
//  ContentView.swift
//  TrackAndSnitch
//
//  Created by Whyyy on 06/10/2024.
//
import SwiftUI
//
struct ContentView: View {
    @State private var shine = false
    @State private var showingInstructions = false // State to manage the instructions sheet
    ////
    // Custom color for the buttons
    let buttonColor = Color(UIColor(red: 107/255, green: 78/255, blue: 69/255, alpha: 1)) // #6B4E45
    
    var body: some View {
        NavigationView {  // Add NavigationView to the entire view
            ZStack {
                // Background Image
                Image("BackgroundImage") // Your background image
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    // Information icon in the top-right corner
                    HStack {
                        Spacer()
//                        Button(action: {
//                            showingInstructions.toggle() // Show instructions when tapped
//                        }) {
//                            Image(systemName: "info.circle")
//                                .font(.system(size: 24))
//                                .foregroundColor(.white)
//                                .padding(.trailing, 40)
//                                .padding(.top, 20)
//                        }
                    }
                    
                    // ZStack for stars behind the title
                    ZStack{
                        
                        FourPointStar()
                            .fill(Color.white)
                            .frame(width: 40, height: 15)
                            .opacity(shine ? 1.0 : 0.5) // Glowing effect
                            .animation(.easeInOut(duration: 1.0).repeatForever(), value: shine)
                            .offset(x: -176, y: -40) // Static position
                        
                        FourPointStar()
                            .fill(Color.white)
                            .frame(width: 40, height: 20)
                            .opacity(shine ? 1.0 : 0.5)
                            .animation(.easeInOut(duration: 1.2).repeatForever(), value: shine)
                            .offset(x: -66, y: -155)
                        
                        FourPointStar()
                            .fill(Color.white)
                            .frame(width: 40, height: 20)
                            .opacity(shine ? 1.0 : 0.5)
                            .animation(.easeInOut(duration: 1.2).repeatForever(), value: shine)
                            .offset(x: 148, y: -5)
                        
                        FourPointStar()
                            .fill(Color.white)
                            .frame(width: 40, height: 20)
                            .opacity(shine ? 1.0 : 0.5)
                            .animation(.easeInOut(duration: 1.2).repeatForever(), value: shine)
                            .offset(x: 53, y: -1)
                        
                        FourPointStar()
                            .fill(Color.white)
                            .frame(width: 40, height: 20)
                            .opacity(shine ? 1.0 : 0.5)
                            .animation(.easeInOut(duration: 1.2).repeatForever(), value: shine)
                            .offset(x: -134, y: 90)
                        
                        FourPointStar()
                            .fill(Color.white)
                            .frame(width: 40, height: 20)
                            .opacity(shine ? 1.0 : 0.5)
                            .animation(.easeInOut(duration: 1.2).repeatForever(), value: shine)
                            .offset(x: -20, y: 49)
                        
                        FourPointStar()
                            .fill(Color.white)
                            .frame(width: 40, height: 20)
                            .opacity(shine ? 1.0 : 0.5)
                            .animation(.easeInOut(duration: 1.2).repeatForever(), value: shine)
                            .offset(x: 100, y: -60)
                        
                        FourPointStar()
                            .fill(Color.white)
                            .frame(width: 40, height: 20)
                            .opacity(shine ? 1.0 : 0.5)
                            .animation(.easeInOut(duration: 1.2).repeatForever(), value: shine)
                            .offset(x: 106, y: 130)
                        
                        FourPointStar()
                            .fill(Color.white)
                            .frame(width: 40, height: 20)
                            .opacity(shine ? 1.0 : 0.5)
                            .animation(.easeInOut(duration: 1.2).repeatForever(), value: shine)
                            .offset(x: 59, y: 65)
                        
                        FourPointStar()
                            .fill(Color.white)
                            .frame(width: 40, height: 10)
                            .opacity(shine ? 1.0 : 0.5)
                            .animation(.easeInOut(duration: 1.4).repeatForever(), value: shine)
                            .offset(x: -64, y: -100)
                        
                        FourPointStar()
                            .fill(Color.white)
                            .frame(width: 40, height: 20)
                            .opacity(shine ? 1.0 : 0.5)
                            .animation(.easeInOut(duration: 1.2).repeatForever(), value: shine)
                            .offset(x: -7, y: -20)
                        
                        FourPointStar()
                            .fill(Color.white)
                            .frame(width: 40, height: 20)
                            .opacity(shine ? 1.0 : 0.5)
                            .animation(.easeInOut(duration: 1.2).repeatForever(), value: shine)
                            .offset(x: -146, y: 20)
                        
                        FourPointStar()
                            .fill(Color.white)
                            .frame(width: 40, height: 20)
                            .opacity(shine ? 1.0 : 0.5)
                            .animation(.easeInOut(duration: 1.2).repeatForever(), value: shine)
                            .offset(x: 20, y: -134)
                        
                        FourPointStar()
                            .fill(Color.white)
                            .frame(width: 40, height: 14)
                            .opacity(shine ? 1.0 : 0.5)
                            .animation(.easeInOut(duration: 1.3).repeatForever(), value: shine)
                            .offset(x: 119, y: 34)
                        
                        FourPointStar()
                            .fill(Color.white)
                            .frame(width: 40, height: 20)
                            .opacity(shine ? 1.0 : 0.5)
                            .animation(.easeInOut(duration: 1.2).repeatForever(), value: shine)
                            .offset(x: 120, y: 70)
                        
                        FourPointStar()
                            .fill(Color.white)
                            .frame(width: 40, height: 18)
                            .opacity(shine ? 1.0 : 0.5)
                            .animation(.easeInOut(duration: 1.1).repeatForever(), value: shine)
                            .offset(x: -120, y: -70)
                        
                        FourPointStar()
                            .fill(Color.white)
                            .frame(width: 40, height: 20)
                            .opacity(shine ? 1.0 : 0.5)
                            .animation(.easeInOut(duration: 1.2).repeatForever(), value: shine)
                            .offset(x: -52, y: 122)
                        
                        FourPointStar()
                            .fill(Color.white)
                            .frame(width: 40, height: 16)
                            .opacity(shine ? 1.0 : 0.5)
                            .animation(.easeInOut(duration: 1.5).repeatForever(), value: shine)
                            .offset(x: 50, y: -100)
                    }
                    .padding(.top, 70)
                    
                    .frame(height: 200) // Restrict the star area to the top
                    

                    Text("WELCOME")
                        .multilineTextAlignment(.center)
                        .padding(.top, 80)
                        .foregroundColor(Color(red: 0.975, green: 0.916, blue: 0.817))
                        .font(.system(size: 36, weight: .heavy, design: .rounded))
                    
                    Text("TO")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.975, green: 0.916, blue: 0.817))
                        .font(.system(size: 36, weight: .heavy, design: .rounded))
                    
                    Text("SNEAK OR SEEK")
                        .multilineTextAlignment(.center)
//                        .padding(.bottom, 80)
                        .foregroundColor(Color(red: 0.975, green: 0.916, blue: 0.817))
                        .font(.system(size: 36, weight: .heavy, design: .rounded))
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    // Logo image with a frame overlay
                    Image("squarelogo")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white, lineWidth: 4)
                        )
                    Spacer()
                    
                    // Start Button with NavigationLink
                    NavigationLink(destination: GameInstructions()) { // Navigate to GameInstructions when tapped
                        Text("Start")
                            .font(.system(size: 22, weight: .regular, design: .rounded))
                            .frame(width: 150, height: 50)
                            .background(buttonColor)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 40)
                }.padding(.trailing, 50)
                .padding(.bottom, 50)
                .onAppear {
                    shine.toggle() // Start the glow animation
                }
                .sheet(isPresented: $showingInstructions) {
                    // Instructions Sheet
                    VStack(spacing: 20) {
                        Text("Instructions")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                        
                        Text("""
                             1. Tap the 'Start' button to begin.
                             2. Use the logo page for navigation.
                             3. Follow on-screen prompts for the next steps.
                             """)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Button("Close") {
                            showingInstructions = false // Close the sheet
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding()
                }
            }
        }
    }
}

// Custom Four-Point Star Shape
struct FourPointStar: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        
        let starPath = Path { path in
            // Starting point (Top middle)
            path.move(to: CGPoint(x: width / 2, y: 0))
            
            // Drawing points of the four-pointed star
            path.addLine(to: CGPoint(x: width * 0.65, y: height / 2))
            path.addLine(to: CGPoint(x: width / 2, y: height))
            path.addLine(to: CGPoint(x: width * 0.35, y: height / 2))
            path.closeSubpath()
        }
        return starPath
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
