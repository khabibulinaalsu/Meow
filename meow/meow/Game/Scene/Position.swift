import SpriteKit
import GameplayKit

final class Position: UIButton {
    var isOccupied: Bool = false
    var num: Int = 1
    
    convenience init(frame: CGRect, num: Int) {
        self.init(frame: frame)
        self.num = num
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
