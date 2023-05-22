import UIKit
import SwiftUI
import SpriteKit

final class GameController: UIViewController {
 
    let session: Session
    var positions: [Position] = []
    var changeCat: ((Position, Cat?) -> Void)?
    private var action: SKAction?
    private var node = SKSpriteNode()
    private var cats: [Int:CatUnit] = [:]
    private let playButton = UIButton(type: .system)
    private var isPlaying: Bool = false
    private var listener = SKNode()
    private var audioWork: DispatchWorkItem?
    
    init(session: Session) {
        self.session = session
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupPositions()
        setupPlayButton()
        setupListener()
        //runAudio()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupPositions() {
        
        // TODO: сложные расчеты для полуэллипса
        
        let xConst: CGFloat = 0.8 * view.frame.width / CGFloat(session.cols + 1)
        let yConst: CGFloat = 0.8 * view.frame.height / CGFloat(session.rows + 1)
        let radiusX: CGFloat = xConst / 1.5
        let radiusY: CGFloat = yConst / 1.5
        
        for i in 1...session.num {
            let a: Int = (i - 1) % session.rows
            let b: Int = (i - 1) / session.rows
            
            let fromLeft: CGFloat = 0.1 * view.frame.width + CGFloat(b + 1) * xConst - 0.5 * radiusX
            let fromTop: CGFloat = 0.1 * view.frame.height + CGFloat(a + 1) * yConst - 0.5 * radiusY
            
            let frame = CGRect(x: fromLeft, y: fromTop, width: radiusX, height: radiusY)
            let grayView = UIView(frame: frame)
            view.addSubview(grayView)
            grayView.backgroundColor = .systemGray4
            grayView.layer.cornerRadius =  min(frame.width, frame.height) / 2.0
            
            let y = frame.origin.y + frame.height - frame.width
            let point = CGPoint(x: frame.origin.x, y: y)
            let size = CGSize(width: frame.width, height: frame.width)
            let frameOfButton = CGRect(origin: point, size: size)
            let v = Position(frame: frameOfButton, num: i)
            v.addTarget(self, action: #selector(openChange), for: .touchUpInside)
            positions.append(v)
            setupCurrentPosition(v.num)
        }
    }
    
    func setupCurrentPosition(_ position: Int) {
        let pos = positions[position-1]
        pos.removeFromSuperview()
        for sub in self.view.subviews {
            if sub.frame == pos.frame {
                sub.removeFromSuperview()
            }
        }
        let view = SKView(frame: pos.frame)
        let cat = session.curSes[position]
        if let cat = cat {
            pos.isOccupied = true
            let unit = CatUnit(cat: cat, size: pos.frame.size)
            self.view.addSubview(view)
            view.presentScene(unit)
            cats[position] = unit
        } else {
            cats[position] = nil
        }
        view.backgroundColor = .clear
        self.view.addSubview(pos)
        pos.backgroundColor = .clear
    }
    
    func runAudio() {
        let nok = countNok()
        var j = 0
        audioWork = DispatchWorkItem {
            for (key, cat) in self.session.curSes {
                let lenPattern = self.countLen(cat: cat)
                let x = j % lenPattern
                if cat.pattern.contains(x) {
                    self.cats[key]?.singCat()
                }
            }
            j += 1
        }
        for i in 0..<nok {
            if let audioWork = audioWork {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.3, execute: audioWork)
            }
        }
        /*
        for (_, unit) in self.cats {
            unit.animateCat()
        }
         */
    }
    
    private func countNok() -> Int {
        return 90
    }
    
    private func countLen(cat: Cat) -> Int {
        let x: Int = (cat.pattern.max() ?? 9) / 10
        return (x + 1) * 10
    }
    
    private func stopAudio() {
        audioWork?.cancel()
        for (_, unit) in self.cats {
            unit.stopAll()
        }
    }
    
    private func setupListener() {
        listener.position = view.center
        let skview = SKView()
        view.addSubview(skview)
        skview.translatesAutoresizingMaskIntoConstraints = false
        skview.heightAnchor.constraint(equalTo: skview.widthAnchor).isActive = true
        skview.widthAnchor.constraint(equalToConstant: 20).isActive = true
        skview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        skview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        let scene = SKScene()
        skview.presentScene(scene)
        skview.backgroundColor = .clear
        scene.backgroundColor = .clear
        scene.addChild(listener)
    }
    
    private func setupPlayButton() {
        view.addSubview(playButton)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        playButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        playButton.widthAnchor.constraint(equalTo: playButton.heightAnchor).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        playButton.backgroundColor = .systemBackground // .systemGray4
        playButton.layer.cornerRadius = 20
        playButton.setTitle("", for: .normal)
        playButton.setTitleColor(.label, for: .normal)
        playButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        playButton.addTarget(self, action: #selector(playMusic), for: .touchUpInside)
    }
    
    @objc
    private func playMusic(_ sender: UIButton) {
        if isPlaying {
            stopAudio()
            isPlaying = false
        } else {
            isPlaying = true
            runAudio()
        }
    }
    
    @objc
    private func openChange(_ sender: Position) {
        stopAudio()
        changeCat?(sender, session.curSes[sender.num])
    }
}
