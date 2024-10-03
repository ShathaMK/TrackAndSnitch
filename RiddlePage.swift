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
    
    var body: some View {
        ZStack {
            // Display the front card image
            Image("Rectangle")
                .resizable()
                .scaledToFill()
                .frame(width: 240, height:400)
                .shadow(color: .gray, radius: 3, x: 0, y: 2)
            Text("Time is gold").foregroundStyle(Color(hex:0x902A39)).font(.system(.title,design:.rounded))
           

            //The radius is the shadow all around the card
            //x is the shadow on the right
            // y is the shadow on the bottom
        }// end of ZStack
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
    var body: some View {

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
                Text("here's a riddle ").font(.system(.callout,design: .rounded)).padding(.top,25)
            
                Spacer()
                Button(action: {}){
                    Text("Continue")
                        .frame(width: 240,height: 45)
                        .background(Color(hex:0x6B4F44))
                        .foregroundStyle(.white).cornerRadius(10)
                   
                }.padding(.bottom,40)
               
            }.foregroundStyle(Color(hex:0x6B4F44))
                   // end of VStack
            // call the card front view
            
            RiddleFront(width: width, height: height, degree: $frontDegree)
            // call the card front view
             CardBack(width: width, height: height, degree: $backDegree)
           
        }.onReceive(timer){
            time in
            // Make sure the person is active (inside the app) before starting counting down
            guard isActive else{return}
            // make sure the time is postive number
            if timeRemaining>0{
                timeRemaining-=1
            }
        }.onChange(of:scenePhase){
            if scenePhase == .active{
                isActive = true
            }
            else{
                isActive = false
            }
        }.onTapGesture {
             flipCard ()
         }
     }
    }


#Preview {
    RiddlePage()
}


