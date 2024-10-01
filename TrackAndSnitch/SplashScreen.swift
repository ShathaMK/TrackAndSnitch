import SwiftUI
import DotLottie

struct SplashScreen: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color(hex: 0xE9DFCF).ignoresSafeArea()
            
            Text("Track & Snitch")
                .fontWeight(.semibold)
              //.font(.custom("GloriaHallelujah-Regular", size: 40))
              .font(.system(size: 40, design: .rounded))
                .padding(.bottom, 300)
                .foregroundStyle(Color(hex: 0x6B4F44))
                .opacity(isAnimating ? 1.0 : 0.0) // Fade-in effect
                .animation(.easeInOut(duration: 2), value: isAnimating)
  
            DotLottieAnimation(
                webURL: "https://lottie.host/79ddcdf1-07b0-4453-8e91-84838ace40e5/p3cjR1wQ2M.json",
                config: AnimationConfig(autoplay: true, loop: true)
            ).view()
        }
        .onAppear {
            isAnimating = true // Fade in the text
        }
    }
  init(){
        for familyName in UIFont.familyNames{
            print(familyName)
            for fontName in UIFont.fontNames(forFamilyName: familyName)
            {
                print("--\(fontName)")
            }
        }
    }
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
