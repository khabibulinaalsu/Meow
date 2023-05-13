import UIKit

final class NewGameCell: UITableViewCell {
    static let reuseIdentifier = "newGame"
    private var clickToGame = UIButton(type: .system)
    var click: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
        super.backgroundColor = .clear 
    }
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.layer.cornerRadius = 24
        contentView.backgroundColor = .systemGray4
        contentView.addSubview(clickToGame)
        clickToGame.translatesAutoresizingMaskIntoConstraints = false
        clickToGame.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        clickToGame.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        clickToGame.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        clickToGame.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        clickToGame.addTarget(self, action: #selector(nextScreen), for: .touchUpInside)
        
        clickToGame.setTitle("New Game", for: .normal)
        clickToGame.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        clickToGame.setTitleColor(.label, for: .normal)
    }
    
    @objc
    func nextScreen(_ sender: UIButton) {
        click?()
    }
}
