import UIKit

class MainController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        setupHuinu()
    }
    
    func setupHuinu() {
        let v = UIButton(type: .system)
        view.addSubview(v)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        v.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        v.heightAnchor.constraint(equalToConstant: 100).isActive = true
        v.widthAnchor.constraint(equalToConstant: 200).isActive = true
        v.backgroundColor =  .red
        v.layer.borderColor = .init(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
        v.layer.borderWidth = 20.0
        v.setTitle("hyu", for: .normal)
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
}

