import UIKit

final class NotaCell: UICollectionViewCell {
    static let reuseIdentifier = "note"
    
    private var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupLabel()
        setupSelected()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel() {
        backgroundView = UIView(frame: contentView.frame)
        backgroundView?.layer.cornerRadius = 20
        backgroundView?.backgroundColor = .systemGray6
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        label.textColor = .systemGray2
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        label.layer.cornerRadius = 20
        label.backgroundColor = .clear
    }
    private func setupSelected() {
        let uiview = UIView()
        let select = UIView()
        self.selectedBackgroundView = uiview
        uiview.addSubview(select)
        uiview.backgroundColor = .clear
        select.translatesAutoresizingMaskIntoConstraints = false
        select.centerXAnchor.constraint(equalTo: uiview.centerXAnchor).isActive = true
        select.centerYAnchor.constraint(equalTo: uiview.centerYAnchor).isActive = true
        select.widthAnchor.constraint(equalTo: select.heightAnchor).isActive = true
        select.heightAnchor.constraint(equalToConstant: 40).isActive = true
        select.backgroundColor = .systemGray
        select.layer.cornerRadius = 20
    }
    
    public func configure(num: Int) {
        label.text = "\(num+1)"
    }
}
