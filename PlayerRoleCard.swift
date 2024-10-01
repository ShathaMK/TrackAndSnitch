//
//  PlayerRoleCard.swift
//  TrackAndSnitch
//
//  Created by Shatha Almukhaild on 28/03/1446 AH.
//

import SwiftUI
// struct for the card front
struct CardFront: View {
    // The width of the card
    let width: CGFloat
    // The height of the card
    let height: CGFloat
    // The degree of rotation for the card
    @Binding var degree: Double

    var body: some View {
        ZStack {
            // Display the front card image
            Image("CardFrontTheif")                 .resizable()
                .scaledToFill()
                .frame(width: 240, height:400)
                .shadow(color: .gray, radius: 3, x: 0, y: 2)
            //The radius is the shadow all around the card
            //x is the shadow on the right
            // y is the shadow on the bottom
        }// end of ZStack
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
        // The x and y and z repersent the diraction of the filp
    }
}
// struct for the card back
struct CardBack: View {
    // The width of the card
    let width: CGFloat
    // The height of the card
    let height: CGFloat
    // The degree of rotation for the card
    @Binding var degree: Double
    var body: some View {
        ZStack {
            // Display the back card image
            Image("CardBack")
                .resizable()
                .scaledToFill()
                .frame(width: 240, height:400)
              
                .shadow(color: .gray, radius: 3, x: 0, y: 0)
            // The radius is the shadow all around the card
            //x is the shadow on the right
            // y is the shadow on the bottom
        }
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
        // The x and y and z repersent the diraction of the filp
    }
}

struct PlayerRoleCard: View {
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
    func flipCard () {
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
    var body: some View {

        ZStack {
   // background color
            Color(hex: 0xE9DFCF).ignoresSafeArea()
            
            VStack{
               
                Text("Round - 1 ").font(.system(.largeTitle,design: .rounded)).fontWeight(.semibold)
                Text("Player 1 flip the card").font(.system(.title2,design: .rounded))
                // spacing for the title & button placement
                Spacer()
                
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Button(action: {}){
                    Text("Continue")
                        .frame(width: 240,height: 45)
                        .background(Color(hex:0x6B4F44))
                        .foregroundStyle(.white).cornerRadius(10)
                   
                }
                Spacer()
            }.foregroundStyle(Color(hex:0x6B4F44))
                   // end of VStack
            // call the card front view
             CardFront(width: width, height: height, degree: $frontDegree)
            // call the card front view
             CardBack(width: width, height: height, degree: $backDegree)
         }.onTapGesture {
             flipCard ()
         }
     }
    }


#Preview {
    PlayerRoleCard()
}


