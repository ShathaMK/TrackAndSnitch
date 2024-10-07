import SwiftUI
import DotLottie

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var navigateToPlayerView = false // State to trigger navigation
    
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
                
                // Delay of 5 seconds before navigating to PlayerView
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    navigateToPlayerView = true
                }
            }
        }
        .navigationBarBackButtonHidden(true) // Hide the back button here
        .background(
            // Navigation to PlayerView after 5 seconds
            NavigationLink(destination: playersView(), isActive: $navigateToPlayerView) {
                EmptyView()
            }
                .hidden() // Hide the NavigationLink itself
        )
        .navigationBarBackButtonHidden(true).navigationBarBackButtonHidden(true)
    }
}

//    init() {
//        for familyName in UIFont.familyNames {
//            print(familyName)
//            for fontName in UIFont.fontNames(forFamilyName: familyName) {
//                print("--\(fontName)")
//            }
//        }
//    }
//}

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
