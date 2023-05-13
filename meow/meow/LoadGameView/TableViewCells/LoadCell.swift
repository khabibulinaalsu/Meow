import UIKit

final class LoadCell: UITableViewCell {
    
    static let reuseIdentifier = "load"
    private var gameName = UILabel()
    private var dateOfCreation = UILabel()
    private var clickToGame = UIButton(type: .system)
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .medium
        df.locale = Locale(identifier: "en_US_POSIX")
        return df
    }()
    var click: ((Date) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupCell()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        super.backgroundColor = .clear
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
    }
    
    private func setupCell() {
        // TODO: цвет размер текста
        contentView.layer.cornerRadius = 24
        contentView.backgroundColor = .systemGray6
        [gameName, dateOfCreation].forEach {
            $0.textColor = .label
            $0.numberOfLines = 0
            $0.backgroundColor = .clear
        }
        gameName.font = .systemFont(ofSize: 24, weight: .bold)
        dateOfCreation.font = .systemFont(ofSize: 16, weight: .regular)
        
        let labels = UIStackView(arrangedSubviews: [gameName, dateOfCreation])
        labels.axis = .vertical
        labels.distribution = .equalSpacing
        contentView.addSubview(labels)
        labels.translatesAutoresizingMaskIntoConstraints = false
        labels.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        labels.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        contentView.addSubview(clickToGame)
        clickToGame.translatesAutoresizingMaskIntoConstraints = false
        clickToGame.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        clickToGame.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        clickToGame.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        clickToGame.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        clickToGame.addTarget(self, action: #selector(nextScreen), for: .touchUpInside)
    }

    public func configure(_ note: GameInfo) {
        gameName.text = note.name
        dateOfCreation.text = dateFormatter.string(from: note.date)
    }
    
    @objc
    func nextScreen(_ sender: UIButton) {
        let dateString: String = dateOfCreation.text ?? ""
        click?(dateFormatter.date(from: dateString) ?? Date.now)
    }
}
