import SwiftUI

struct Dolldisplay: View {
    private let numberOfStars = 10
    private let minStarDistance: CGFloat = 100.0
    private let starPlacementRange: CGFloat = 200
    private let starRegenerationInterval: Double = 2.0

    @State private var starPositions: [CGSize] = []
    @State private var imageName: String = ""
    @State private var savedImageName: String? = nil
    @State private var timer: Timer?
    @State private var showConfirmation: Bool = false
    @State private var isReadyToStart: Bool = false

    var body: some View {
        
            ZStack {
                NavigationLink(destination: IntroPage1())  {}
                .navigationBarBackButtonHidden(true) // Hiding back button
                
                Color.cyan.opacity(0.2)
                    .edgesIgnoringSafeArea(.all)

                ForEach(0..<starPositions.count, id: \.self) { index in
                    StarShape()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color.white.opacity(0.6))
                        .offset(x: starPositions[index].width, y: starPositions[index].height)
                }

                VStack {
                    // Confirmation Notification
                    if showConfirmation {
                        Text("Name Saved Successfully")
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green.opacity(0.5))
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .transition(.opacity)
                            .animation(.easeInOut, value: showConfirmation)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation {
                                        showConfirmation = false
                                    }
                                }
                            }
                    }

                    // Back Button
                    HStack {
                        NavigationLink(destination: ensuringUserEmotion()) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)


                                .font(.system(size:20, weight: .bold))

                                .font(.system(size: 13,weight: .bold))


                                .font(.system(size: 20, weight: .bold))

                                .padding()
                                .background(Color.yellow.opacity(0.8))
                                .clipShape(Circle())
                                .navigationBarBackButtonHidden(true) // Hiding back button
                        }
                       
                        Spacer()
                    }
                    .padding(.top, 40)
                    .padding(.leading, 20)

                    Text("Here is your doll!")
                        .font(.largeTitle)
                        .padding(.top, 20)
                        .fontWeight(.bold)
                        .foregroundColor(.black.opacity(0.7))

                    Spacer()

                    Image("dolll") // Replace with your actual image name
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 250)
                        .padding(.top, 10)

                    // Display the saved name below the doll
                    if let name = savedImageName {
                        Text(name)
                            .font(.headline)
                            .padding(.top, 10)
                            .foregroundColor(.black.opacity(0.8))
                    }

                    Spacer()

                    VStack {
                        // Change Doll Name Text
                        Text("Name it!")
                            .font(.largeTitle)
                            .padding(.top, 20)
                            .fontWeight(.bold)
                            .foregroundColor(.black.opacity(0.7))

                        TextField("Enter doll Name", text: $imageName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 250)
                            .shadow(radius: 3)

                        // Button Row
                        HStack(spacing: 10) {
                            // Save Button
                            Button(action: {
                                saveName()
                            }) {
                                Text("Save")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 120)
                                    .background(.yellow.opacity(0.8))
                                    .cornerRadius(5)
                            }

                            // No Thanks Button
                            Button(action: {
                                savedImageName = nil // Clear the saved name
                                isReadyToStart = true // Show the start button
                            }) {
                                Text("No Thanks")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 120)
                                    .background(Color.red.opacity(0.7))
                                    .cornerRadius(5)
                            }
                        }
                        .padding(.top, 10)

                        // Start Button
                        if isReadyToStart {
                            NavigationLink(destination: MainGameLogicPage()) { // Navigate to MainGameLogicPage
                                Text("Start")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 120)
                                    .background(Color.blue.opacity(0.5))
                                    .cornerRadius(30)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 30)
                                            .stroke(Color.blue, lineWidth: 2)
                                    )
                                    .padding(.top, 20)
                            }
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
            .onAppear {
                generateStarPositions()
                startStarRegeneration()
            }
            .onDisappear {
                timer?.invalidate()
            }
        
        
    }

    func saveName() {
        savedImageName = imageName
        showConfirmation = true
        isReadyToStart = true
    }

    func generateStarPositions() {
        DispatchQueue.global(qos: .userInitiated).async {
            var positions: [CGSize] = []
            
            while positions.count < numberOfStars {
                let newPosition = CGSize(
                    width: CGFloat.random(in: -starPlacementRange...starPlacementRange),
                    height: CGFloat.random(in: -starPlacementRange...starPlacementRange)
                )
                
                if positions.allSatisfy({ distance($0, newPosition) >= minStarDistance }) {
                    positions.append(newPosition)
                }
            }
            
            DispatchQueue.main.async {
                starPositions = positions
            }
        }
    }

    func startStarRegeneration() {
        timer = Timer.scheduledTimer(withTimeInterval: starRegenerationInterval, repeats: true) { _ in
            withAnimation {
                starPositions.removeAll() // Fade out stars
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                generateStarPositions() // Generate new star positions
            }
        }
    }

    func distance(_ a: CGSize, _ b: CGSize) -> CGFloat {
        return sqrt(pow(a.width - b.width, 2) + pow(a.height - b.height, 2))
    }
}

struct starShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let points = [
            CGPoint(x: rect.width / 2, y: 0),
            CGPoint(x: rect.width, y: rect.height / 2),
            CGPoint(x: rect.width / 2, y: rect.height),
            CGPoint(x: 0, y: rect.height / 2)
        ]
        path.move(to: points[0])
        path.addLines(points)
        path.closeSubpath()
        return path
    }
}

// New View for the Name Saved Page
struct NameSavedView: View {
    var savedName: String?

    var body: some View {
        VStack {
            Text("Name Saved!")
                .font(.largeTitle)
                .padding()
            if let name = savedName {
                Text(name) // Just show the name directly
            } else {
                Text("No name was saved.")
            }
        }
        .font(.title)
        .padding()
    }
}

struct DollDisplay_Previews: PreviewProvider {
    static var previews: some View {
        Dolldisplay()
    }
}

