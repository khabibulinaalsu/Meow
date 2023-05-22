import UIKit

final class MakePatternController: UIViewController {
    private var pattern: [Int] {
        didSet {
            pattern.sort()
        }
    }
    private var tabs = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let plusMinus = UIStepper()
    private var saveButton = UIButton(type: .system)
    
    var save: (([Int]) -> Void)?
    
    init(pattern: [Int]) {
        self.pattern = pattern
        let x: Int = (pattern.max() ?? 9) / 10
        self.plusMinus.value = Double((x + 1)) * 10.0
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNotes()
        setupStepper()
        setupSaveButton()
    }
    
    private func setupNotes() {
        view.addSubview(tabs)
        tabs.backgroundColor = .clear
        tabs.register(NotaCell.self, forCellWithReuseIdentifier: NotaCell.reuseIdentifier)
        tabs.keyboardDismissMode = .onDrag
        tabs.dataSource = self
        tabs.delegate = self
        tabs.allowsMultipleSelection = true
        for ind in pattern {
            tabs.selectItem(at: IndexPath(row: ind, section: 0), animated: false, scrollPosition: .centeredVertically)
        }
        tabs.translatesAutoresizingMaskIntoConstraints = false
        tabs.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tabs.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10).isActive = true
        tabs.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 0.16 * view.frame.width - 10.0
        ).isActive = true
        tabs.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.1 * view.frame.width - 9.0).isActive = true
    }
    private func setupStepper() {
        plusMinus.minimumValue = 10
        plusMinus.maximumValue = 100
        plusMinus.stepValue = 10
        view.addSubview(plusMinus)
        plusMinus.translatesAutoresizingMaskIntoConstraints = false
        plusMinus.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusMinus.topAnchor.constraint(equalTo: tabs.bottomAnchor, constant: 10).isActive = true
        plusMinus.addTarget(self, action: #selector(lenChanged), for: .valueChanged)
    }
    private func setupSaveButton() {
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.label, for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        saveButton.backgroundColor = .systemGray4
        saveButton.layer.cornerRadius = 12
        saveButton.addTarget(self, action: #selector(saveData), for: .touchUpInside)
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.topAnchor.constraint(equalTo: plusMinus.topAnchor).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: tabs.trailingAnchor, constant: -20).isActive = true
        saveButton.heightAnchor.constraint(equalTo: plusMinus.heightAnchor).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    @objc
    private func lenChanged(_ sender: UIStepper) {
        tabs.reloadData()
        for ind in pattern {
            if Double(ind) < plusMinus.value {
                tabs.selectItem(at: IndexPath(row: ind, section: 0), animated: false, scrollPosition: .centeredVertically)
            } else {
                if let x = pattern.firstIndex(of: ind) {
                    pattern.remove(at: x)
                }
            }
        }
    }
    @objc
    private func saveData(_ sender: UIButton) {
        save?(pattern)
    }
}

extension MakePatternController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(plusMinus.value)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = tabs.dequeueReusableCell(withReuseIdentifier: NotaCell.reuseIdentifier, for: indexPath) as? NotaCell {
            cell.configure(num: indexPath.row)
            return cell
        }
        return UICollectionViewCell()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension MakePatternController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 0.08 * view.frame.width, height: 0.08 * view.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}

extension MakePatternController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pattern.append(indexPath.row)
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let x = pattern.firstIndex(of: indexPath.row) {
            pattern.remove(at: x)
        }
    }
}
