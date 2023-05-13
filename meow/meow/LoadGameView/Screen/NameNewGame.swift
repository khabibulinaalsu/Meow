import UIKit

final class NameGameController: UIViewController {
    private var label = UILabel()
    private var name = UITextView()
    private var rowLabel = UILabel()
    private var rows = UITextView()
    private var colLabel = UILabel()
    private var cols = UITextView()
    private let beginButton = UIButton(type: .system)
    var addGame: ((String, Int, Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
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
    
    private func setupView() {
        let rowsStack = UIStackView(arrangedSubviews: [rowLabel, rows])
        let colsStack = UIStackView(arrangedSubviews: [colLabel, cols])
        [rowsStack, colsStack].forEach {
            $0.axis = .vertical
            $0.spacing = 0
            $0.distribution = .fillEqually
        }
        
        let rowcol = UIStackView(arrangedSubviews: [rowsStack, colsStack])
        rowcol.axis = .horizontal
        rowcol.spacing = 10
        rowcol.distribution = .fillEqually
        
        let labelsStack = UIStackView(arrangedSubviews: [label, name, rowcol])
        labelsStack.axis = .vertical
        labelsStack.spacing = 0
        
        let contentStack = UIStackView(arrangedSubviews: [labelsStack, beginButton])
        view.addSubview(contentStack)
        contentStack.axis = .vertical
        contentStack.spacing = 10
        contentStack.distribution = .fill
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contentStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        contentStack.widthAnchor.constraint(equalToConstant: 360).isActive = true
        
        [label, name, rows, cols, rowLabel, colLabel, beginButton].forEach {
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        
        //contentStack.heightAnchor.constraint(equalToConstant: 240).isActive = true
        
        [name, rows, cols].forEach {
            $0.layer.cornerRadius = 24
            $0.backgroundColor = .systemGray6
            $0.textColor = .label
            $0.font = .systemFont(ofSize: 24, weight: .regular)
            $0.textAlignment = .center
            $0.autocapitalizationType = .none
            $0.autocorrectionType = .no
        }
        [label, rowLabel, colLabel].forEach {
            $0.textColor = .label
            $0.font = .systemFont(ofSize: 24, weight: .regular)
        }
        label.text = "Enter name for this session:"
        rowLabel.text = "Amount of rows:"
        colLabel.text = "Amount of cols:"
        
        beginButton.layer.cornerRadius = 24
        beginButton.backgroundColor = .systemGray4
        beginButton.setTitle("Start", for: .normal)
        beginButton.setTitleColor(.label, for: .normal)
        beginButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        beginButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
    }
    
    @objc
    private func startGame(_ sender: UIButton) {
        if name.hasText {
            if let rows = Int(rows.text) {
                if rows > 0 {
                    if let cols = Int(cols.text) {
                        if cols > 0 {
                            addGame?(name.text, rows, cols)
                        }
                    }
                }
            }
        }
    }
}
