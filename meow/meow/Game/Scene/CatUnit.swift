import SpriteKit
import GameplayKit

final class CatUnit: SKScene {
    private let catInfo: Cat
    private var cat = SKSpriteNode()
    private var catMovingFrames: [SKTexture] = []
    private var sound: SKAudioNode
    var isEnabled = true
    
    init(cat: Cat, size: CGSize) {
        self.catInfo = cat
        self.sound = SKAudioNode(fileNamed: "\(cat.type).mp3")
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        buildCat()
      }
    
    private func buildCat() {
        for i in 1...3 {
            let frameName = "cat\(catInfo.type)\(i)"
            catMovingFrames.append(SKTexture(imageNamed: frameName))
        }
        cat = SKSpriteNode(imageNamed: "cat\(catInfo.type)1")
        
        // TODO: position and size
        cat.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        cat.scale(to: CGSize(width: size.width, height: size.height))
        
        addChild(cat)
        sound.speed = 3
        cat.addChild(sound)
        sound.run(SKAction.pause())
    }
    
    func animateCat() {
        sound.run(SKAction.play())
        cat.run(
            SKAction.animate(
                    with: self.catMovingFrames,
                    timePerFrame: 0.1,
                    resize: false,
                    restore: true),
            completion: {
                self.sound.run(SKAction.pause())
            }
        )
    }
}
