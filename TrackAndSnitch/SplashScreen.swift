import SwiftUI
import DotLottie

struct SplashScreen: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            // Background image
            Image("bgpaper")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(0.5)
                
            
            // DotLottie Animation
            DotLottieAnimation(
                webURL: "https://lottie.host/79ddcdf1-07b0-4453-8e91-84838ace40e5/p3cjR1wQ2M.json",
                config: AnimationConfig(autoplay: true, loop: true)
            )
            .view()
            .rotationEffect(Angle(degrees: -10))
            .padding(.bottom, -600)
            .padding(.leading, 20)
            .opacity(0.7)
            // Text
            VStack {
                Text("Seek or Sneak")
                    .fontWeight(.semibold)
                    .font(.system(size: 40, design: .rounded))
                    .foregroundStyle(Color(hex: 0x6B4F44))
                    .padding(.bottom,150)
            }
            .opacity(isAnimating ? 1.0 : 0.0) // Fade-in effect
            .animation(.easeInOut(duration: 2), value: isAnimating)
            .onAppear {
                isAnimating = true // Trigger the animation on appear
            }
        }        .navigationBarBackButtonHidden(true) // Hide the back button here

    }

//    init() {
//        for familyName in UIFont.familyNames {
//            print(familyName)
//            for fontName in UIFont.fontNames(forFamilyName: familyName) {
//                print("--\(fontName)")
//            }
//        }
//    }
}

#Preview {
    SplashScreen()
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double((hex >> 0) & 0xff) / 255,
            opacity: alpha
        )
    }
}
