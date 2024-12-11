//
//  plinkoGameScene.swift
//  gambit
//
//  Created by Nick Mantini on 11/21/24.
//

import SwiftUI
import SpriteKit

class crashGameScene: SKScene, SKPhysicsContactDelegate {
    @Binding var liveGameBalance: Double

    init(liveGameBalance: Binding<Double>, size: CGSize) {
        self._liveGameBalance = liveGameBalance
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        addGradientBackground()
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
    
    }
    
    internal func didBegin(_ contact: SKPhysicsContact) {
        let contactBodyA = contact.bodyA.categoryBitMask
        let contactBodyB = contact.bodyB.categoryBitMask

    }
    
    private func makeVerticalText(from text: String) -> String {
        return text.map { String($0) }.joined(separator: "\n")
    }
    
    override func update(_ currentTime: TimeInterval) {

    }
    
    func addGradientBackground() {
        let size = self.size
        let texture = SKTexture(size: size, colors: [.deepBlack, .lighterBlack, .evenLighterBlack])
        let background = SKSpriteNode(texture: texture)
        background.size = size
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1 // Ensure it is behind all other nodes
        addChild(background)
    }
}

struct ExponentialPathView: View {
    @State private var points: [CGPoint] = [] // Points to draw the curve
    @State private var timer: Timer? // Timer for the animation
    @State private var progress: Double = 0 // Progress value (0 to 1)
    
    let duration: Double = 20.0 // Total duration for the animation
    let interval: Double = 0.05 // Timer interval for adding points

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height / 2 // Use half the height

            Path { path in
                guard !points.isEmpty else { return }
                path.move(to: points.first!) // Start at the first point

                for point in points {
                    path.addLine(to: point) // Add each subsequent point
                }
            }
            .stroke(Color.blue, lineWidth: 2)
        }
        .onAppear {
            startAnimation()
        }
        .onDisappear {
            timer?.invalidate() // Stop the timer when the view disappears
        }
    }

    private func startAnimation() {
        let totalSteps = duration / interval
        var currentStep = 0.0

        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            if currentStep >= totalSteps {
                timer?.invalidate() // Stop when the animation completes
                return
            }

            currentStep += 1
            progress = currentStep / totalSteps

            addPoint(for: progress) // Add the next point
        }
    }

    private func addPoint(for progress: Double) {
        guard progress <= 1 else { return }

        let x = progress // Progress mapped to x-axis (0 to 1)
        let y = exponentialValue(for: progress) // Exponential curve for y-axis (0 to 1)

        // Scale the x and y values to screen dimensions
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height / 2
        let point = CGPoint(x: x * screenWidth, y: screenHeight - (y * screenHeight))

        points.append(point)
    }

    private func exponentialValue(for t: Double) -> Double {
        return pow(2, t * 10) / pow(2, 10) // Scaled exponential growth (0 to 1)
    }
}

struct AnimatedCrashLineView: View {
    @State private var time: Double = 0
    @State private var points: [CGPoint] = []
    @State private var crashMultiplier: Double = 1000
    @State private var isCrashed = false
    @State private var isAnimating = false
    @State private var multiplier: Double = 1

    var body: some View {
        VStack {
            ExponentialPathView()
                .frame(height: 400)

            Text("Multiplier: \(String(format: "%.2f", multiplier))x")
                .font(.largeTitle)
                .foregroundColor(isCrashed ? .red : .green)
                .padding()

            if isCrashed {
                Text("Crashed!")
                    .font(.title)
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action: startGame) {
                Text(isAnimating ? "Reset" : "Start")
                    .font(.title)
                    .padding()
                    .background(isAnimating ? Color.orange : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }

    private func startGame() {
        points = []
        time = 0
        multiplier = 1
        isCrashed = false
        isAnimating = true
        crashMultiplier = Double.random(in: 0...1000) // Random crash point

        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if multiplier >= crashMultiplier {
                isCrashed = true
                isAnimating = false
                timer.invalidate()
            } else {
                time += 2
                let yPos = 300 - exponentialMultiplier(for: time/1000)
                print(time, yPos)
                points.append(CGPoint(x: time, y: yPos))
            }
        }
    }

    let height = 2000.0;
    let coeffB = 0.5;
    
    private func exponentialMultiplier(for t: Double) -> Double {
        let coeffA = height*0.16;
        return coeffA * (exp(coeffB * t) - 1);
    }
}
