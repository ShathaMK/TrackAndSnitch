import SwiftUI

// ---------------------------------- Instruction Card View ----------------------------------

struct InstructionCardView<Content: View>: View {
    let title: String
    let iconName: String
    let content: Content

    private let backgroundColor = Color(red: 0.957, green: 0.918, blue: 0.854)
    private let foregroundColor = Color(red: 0.42, green: 0.34, blue: 0.28)
    private let iconColor = Color(red: 0.57, green: 0.24, blue: 0.24)

    init(title: String, iconName: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.iconName = iconName
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            
            VStack {
                Spacer() // Push card to bottom
                
                // Card content with an icon on top
                ZStack(alignment: .top) {
                    // Background Card
                    VStack(spacing: 25) {
                        Spacer().frame(height: 40) // Space for the icon
                        
                        Text(title)
                            .font(.system(size: 28, weight: .semibold, design: .rounded))
                            .foregroundColor(foregroundColor)
                        
                        content
                            .padding(.bottom, 70)
                            .padding(.horizontal, 20)
                    }
                    .frame(width: geometry.size.width * 0.96)
                    .background(backgroundColor)
                    .cornersRadius(30, corners: [.allCorners])
                    
                    // Icon overlapping with the card
                    Image(systemName: iconName)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .font(.system(size: 200, weight: .light))
                        .foregroundColor(iconColor)
                        .background(backgroundColor)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(backgroundColor, lineWidth: 4))
                        .offset(y: -50)
                }
                .frame(width: geometry.size.width, alignment: .center)
            }
            .ignoresSafeArea()
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

// ---------------------------------- Game Instructions View ----------------------------------

struct GameInstruction: View {
    var body: some View {
        InstructionCardView(title: "Game Instructions", iconName: "info.circle") {
            Text("Strategy meets deception.\nPlay your role, fool your friends, and win the game!")
                .font(.system(size: 22, weight: .regular, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.42, green: 0.34, blue: 0.28))
        }
    }
}

// -------------------------------------- Roles View --------------------------------------

struct RoleView: View {
    var body: some View {
        InstructionCardView(title: "Roles", iconName: "person.2.circle") {
            VStack(alignment: .leading, spacing: 25) {
                RolesItem(iconName: "hand.raised.circle", roleTitle: "Thief", description: "Is assigned a stolen object. The goal is to avoid being caught.")
                RolesItem(iconName: "binoculars.circle", roleTitle: "Tracker", description: "Catch the thief. Identify both the stolen object & thief.")
                RolesItem(iconName: "questionmark.circle", roleTitle: "Helper", description: "Knows who the thief is. Help the thief deceive others.")
                RolesItem(iconName: "theatermasks.circle", roleTitle: "Trickster", description: "Causes confusion, makes things tricky for the other players!")
            }
        }
    }
}

struct RolesItem: View {
    var iconName: String
    var roleTitle: String
    var description: String

    private let iconColor = Color(red: 0.57, green: 0.24, blue: 0.24)
    private let textColor = Color(red: 0.42, green: 0.34, blue: 0.28)

    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            VStack(alignment: .center, spacing: 8) {
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .font(.system(size: 200, weight: .thin))
                    .frame(width: 40, height: 40)
                    .foregroundColor(iconColor)
                Text(roleTitle)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 75, alignment: .center)

            Text(description)
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundColor(textColor)
                .multilineTextAlignment(.leading)
        }
    }
}


//  -------------------------------------- Rounds View --------------------------------------

struct Rounds: View {
    var body: some View {
        InstructionCardView(title: "Rounds", iconName: "arrowshape.forward.circle") {
            Text("After finiishing the round guess the stolen object by solving riddles. Vote on who you think the thief is based on the answers and riddles.")
                .font(.system(size: 22, weight: .regular, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.42, green: 0.34, blue: 0.28))
        }
    }
}

// -------------------------------------- Objective View --------------------------------------

struct Objective: View {
    var body: some View {
        InstructionCardView(title: "Objective", iconName: "target") {
            Text("The catchers must first guess the stolen object based on the riddles. Then, they try to identify the thief through the responses and clues gathered during the game.")
                .font(.system(size: 22, weight: .regular, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.42, green: 0.34, blue: 0.28))
        }
    }
}

// -------------------------------------- Winning View --------------------------------------

struct Winning: View {
    var body: some View {
        InstructionCardView(title: "Winning", iconName: "trophy.circle") {
            Text("The Catchers win if they correctly guess the stolen object and identify the thief.\n\nThe Thief & Helper win if the catchers fail to correctly guess both the stolen object and the thief.")
                .font(.system(size: 22, weight: .regular, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.42, green: 0.34, blue: 0.28))
        }
    }
}

// ---------------------------------- Game Instructions Main View ----------------------------------

struct GameInstructions: View {
    var body: some View {
        ZStack{
            
            // Background Image
            Image("bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            TabView {
                GameInstruction()
                RoleView()
                Rounds()
                Objective()
                Winning()
            }
            .ignoresSafeArea()
            .tabViewStyle(PageTabViewStyle())
            
            .onAppear {
                // Set custom colors for page indicator
                UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color(red: 0.57, green: 0.24, blue: 0.24)) // Active page color
                UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color(red: 0.42, green: 0.34, blue: 0.28).opacity(0.5)) // Inactive page color
            }
        }
    }
}

// ---------------------------------- Rounded Corner Extension ----------------------------------

extension View {
    func cornersRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorners(radius: radius, corners: corners))
    }
}

struct RoundedCorners: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// ---------------------------------- Preview ----------------------------------

struct GameInstructions_Previews: PreviewProvider {
    static var previews: some View {
        GameInstructions()
    }
}
