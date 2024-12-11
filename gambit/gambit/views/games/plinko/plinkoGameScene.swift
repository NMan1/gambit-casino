//
//  plinkoGameScene.swift
//  gambit
//
//  Created by Nick Mantini on 11/21/24.
//

import SwiftUI
import SpriteKit

class plinkoGameScene: SKScene, SKPhysicsContactDelegate {
    @Binding var liveGameBalance: Double

    init(liveGameBalance: Binding<Double>, size: CGSize) {
        self._liveGameBalance = liveGameBalance
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let heightPositioning = 0.70
    let ballDropHeight = 0.70 + 0.07
    
    let pinRows = 12
    var ballRecordings: [[String: Any]?] = []
    let multipliers: [Double] = [1000, 130, 26, 9, 4, 0.2, 0.2, 0.2, 4, 9, 26, 130, 1000]
    let multiplierText: [Double: String] = [
        1000: "1K",
        130: "130",
        26: "26x",
        9: "9x",
        4: "4x",
        2: "2x",
        0.5: "0.5x",
        0.2: "0.2"
    ]
    
    let ballCategory: UInt32 = 0x1 << 0
    let slotCategory: UInt32 = 0x1 << 2
    let pinCategory: UInt32 = 0x1 << 4
        
    struct Position: Codable {
        var ballId: String
        var x: [CGFloat]
        var y: [CGFloat]
    }

    struct Entry: Codable {
        let multiplier: Double
        var positions: [Position]
    }

    var entries: [Entry] = [Entry(multiplier: 1000, positions: []),
                            Entry(multiplier: 130, positions: []),
                            Entry(multiplier: 26, positions: []),
                            Entry(multiplier: 9, positions: []),
                            Entry(multiplier: 4, positions: []),
                            Entry(multiplier: 0.2, positions: []),
    ]
    
    override func didMove(to view: SKView) {
        if (ballRecordings.isEmpty ) {
            if let json = loadJSONFromBundle(fileName: "ballRecordings") {
                ballRecordings = json
            }
        }
        
        addGradientBackground()
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        let pegSpacing: CGFloat = 30
        let pinRadius: CGFloat = 3.5
        let pinPhysicsRadius: CGFloat = 8

        // Create pegs
        for row in 0..<pinRows {
            for col in 0..<(row + 3) {
                let pin = SKShapeNode(circleOfRadius: pinRadius)
                pin.fillColor = .white

                let xOffset = CGFloat(row + 2) * (pegSpacing / 2)
                let xPosition = frame.midX - xOffset + CGFloat(col) * pegSpacing
                let yPosition = (frame.maxY * heightPositioning) - CGFloat(row) * pegSpacing

                pin.position = CGPoint(x: xPosition, y: yPosition)
                pin.physicsBody = SKPhysicsBody(circleOfRadius: pinPhysicsRadius)
                pin.physicsBody!.isDynamic = false
                pin.physicsBody!.restitution = 0.5
                pin.physicsBody!.friction = 0.7
                pin.physicsBody!.categoryBitMask = pinCategory
                
                addChild(pin)
            }
        }

        let lastRowPins = pinRows + 2 // Number of pins in the last row
        let numMultipliers = lastRowPins - 1 // Multipliers = (# of pins in last row - 1)
                
        // Create multiplier slots
        let slotWidth = frame.width / CGFloat(numMultipliers)
        let slotYPosition = (frame.maxY * heightPositioning) - CGFloat(pinRows) * pegSpacing - 10
        
        for (index, multiplier) in multipliers.enumerated() {
            let slot = SKShapeNode(rectOf: CGSize(width: slotWidth - 5, height: 30), cornerRadius: 8)
            let shadow = SKShapeNode(rectOf: CGSize(width: slotWidth - 5, height: 30), cornerRadius: 8)

            if multiplier >= 100 {
                slot.fillColor = UIColor(red: 255/255, green: 0/255, blue: 63/255, alpha: 1.0)
                shadow.fillColor = UIColor(red: 166/255, green: 0/255, blue: 4/255, alpha: 1.0)
            } else if multiplier >= 10 {
                slot.fillColor = UIColor(red: 255/255, green: 96/255, blue: 32/255, alpha: 1.0)
                shadow.fillColor = UIColor(red: 168/255, green: 1/255, blue: 0/255, alpha: 1.0)
            } else if multiplier >= 1 {
                slot.fillColor = UIColor(red: 255/255, green: 144/255, blue: 16/255, alpha: 1.0)
                shadow.fillColor = UIColor(red: 170/255, green: 75/255, blue: 0/255, alpha: 1.0)
            } else {
                slot.fillColor = UIColor(red: 255/255, green: 192/255, blue: 0/255, alpha: 1.0)
                shadow.fillColor = UIColor(red: 171/255, green: 121/255, blue: 0/255, alpha: 1.0)
            }
                        
            slot.strokeColor = .clear
            shadow.strokeColor = .clear
            
            slot.zPosition = 2
            shadow.zPosition = 1
            
            slot.position = CGPoint(
                x: frame.minX + slotWidth * CGFloat(index) + slotWidth / 2,
                y: slotYPosition
            )
            
            shadow.position = CGPoint(
                x: frame.minX + slotWidth * CGFloat(index) + slotWidth / 2,
                y: slotYPosition - 4
            )
            
            slot.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -slotWidth / 2, y: -15, width: slotWidth - 5, height: 30))
            slot.physicsBody!.isDynamic = true
            slot.physicsBody!.categoryBitMask = slotCategory
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = 1
            paragraphStyle.maximumLineHeight = 9
            paragraphStyle.lineSpacing = 1
            
            let text = multiplierText[multiplier] ?? "\(multiplier)x"
            let label = SKLabelNode(attributedText: .init(string: text, attributes: [.paragraphStyle: paragraphStyle]))
            
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.fontName = "Arial-BoldMT"
            label.fontSize = 16
            label.fontColor = .black
            label.horizontalAlignmentMode = .center
            label.verticalAlignmentMode = .center
            label.position = CGPoint(x: 0, y: 2)
            label.zPosition = 1
            
            slot.userData = ["multi": multiplier]
            slot.addChild(label)
            
            addChild(slot)
            addChild(shadow)
        }
    }
    
    func dropBall(multi: Double, liveBalance: Double) {
        var randomRecordingIndex = 0
        for entry in ballRecordings {
            if multi == entry!["multiplier"]! as! Double {
                let posEntires = entry!["positions"] as! [[String: Any]]
                randomRecordingIndex = Int(arc4random_uniform(UInt32(posEntires.count)))
            }
        }
        
        let randomXPos = frame.midX + CGFloat.random(in: 1...18) * (Bool.random() ? 1 : -1)
        let ball = SKShapeNode(circleOfRadius: 5)
        ball.fillColor = .white
        ball.position = CGPoint(
            x: randomXPos,
            y: frame.maxY * ballDropHeight
        )
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        ball.physicsBody!.restitution = 0.3
        ball.physicsBody!.friction = 0.3
        ball.physicsBody!.density = 0.5
        ball.physicsBody!.angularDamping = 0.7
        ball.physicsBody!.linearDamping = 0.3
        ball.physicsBody!.allowsRotation = true
        ball.physicsBody!.categoryBitMask = ballCategory
        ball.physicsBody!.contactTestBitMask = slotCategory
        ball.physicsBody!.collisionBitMask = slotCategory | pinCategory
        ball.name = "ball"
        ball.userData = ["multi": multi, "liveBalance": liveBalance, "randomRecordingIndex": randomRecordingIndex, "frameIndex": 0]
        
        addChild(ball)
    }
    
    internal func didBegin(_ contact: SKPhysicsContact) {
        let contactBodyA = contact.bodyA.categoryBitMask
        let contactBodyB = contact.bodyB.categoryBitMask

        if (contactBodyA == ballCategory && contactBodyB == slotCategory) ||
            (contactBodyA == slotCategory && contactBodyB == ballCategory) {
            
            let ball = (contact.bodyA.categoryBitMask == ballCategory ? contact.bodyA.node : contact.bodyB.node) as? SKShapeNode
            let slot = (contact.bodyA.categoryBitMask == slotCategory ? contact.bodyA.node : contact.bodyB.node) as? SKShapeNode
            
            if (ball != nil) {
                self.liveGameBalance = ball?.userData!["liveBalance"] as! Double
                ball!.removeFromParent()
            }
            
            if (slot != nil) {
                let scaleUp = SKAction.scale(to: 1.2, duration: 0.1)
                let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
                let colorize = SKAction.colorize(with: .green, colorBlendFactor: 1.0, duration: 0.1)
                let revertColor = SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.1)
                let sequence = SKAction.sequence([scaleUp, colorize, scaleDown, revertColor])
               
                slot!.run(sequence)
            }
        }
    }
    
    private func makeVerticalText(from text: String) -> String {
        return text.map { String($0) }.joined(separator: "\n")
    }
    
    override func update(_ currentTime: TimeInterval) {
        enumerateChildNodes(withName: "ball") { node, _ in
            if let ball = node as? SKShapeNode {
                let multi = ball.userData!["multi"] as! Double
                let recordingIndex = ball.userData!["randomRecordingIndex"] as! Int
                let frameIndex = ball.userData!["frameIndex"] as! Int
                
                let multiEntry = self.ballRecordings.first(where: {$0!["multiplier"]! as! Double == multi})
                let recordings = multiEntry!!["positions"] as! [[String: Any]]
                let recording = recordings[recordingIndex]
                
                let x = (recording["x"] as! [Double])[frameIndex]
                let y = (recording["y"] as! [Double])[frameIndex]

                ball.position.x = x
                ball.position.y = y

                ball.userData!["frameIndex"] = ball.userData!["frameIndex"] as! Int + 1
            }
        }
    }
    
    func addGradientBackground() {
        let size = self.size
        let texture = SKTexture(size: size, colors: [UIColor(Color(hex: "0f212e")!),
                                                     UIColor(Color(hex: "0e1e29")!),
                                                             UIColor(Color(hex: "0c1a25")!),
                                                                     UIColor(Color(hex: "0b1720")!),
                                                                             UIColor(Color(hex: "09141c")!),
                                                                                     UIColor(Color(hex: "081117")!),
                                                                                             UIColor(Color(hex: "060d12")!),
                                                                                                     UIColor(Color(hex: "081117")!),
                                                                                                             UIColor(Color(hex: "09141c")!),
                                                                                                                     UIColor(Color(hex: "0b1720")!),
                                                                                                                             UIColor(Color(hex: "0c1a25")!),
                                                                                                                                     UIColor(Color(hex: "0e1e29")!),
                                                                                                                                             UIColor(Color(hex: "0f212e")!),])
        let background = SKSpriteNode(texture: texture)
        background.size = size
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1 // Ensure it is behind all other nodes
        addChild(background)
    }
}
