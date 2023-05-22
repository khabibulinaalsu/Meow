import UIKit
import SpriteKit

final class AddCatController: UIViewController {
    
    var position: Position
    var cat: Cat?
    private let catTypes = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let changeTypeButton = UIButton(type: .system)
    private let changePatternButton = UIButton(type: .system)
    private let dismissCat = UIButton(type: .system)
    private let saveButton = UIButton(type: .system)
    private let exitButton = UIButton(type: .system)
    private let setupView = UIView()
    private let catView = UIView()
    private let catSKView = SKView()
    private let types: [catType] = [.normal, .loud]
    
    var returnToMain: ((Position, Cat?) -> Void)?
    var openMakePattern: (([Int]) -> Void)?
    
    // TODO: changePlace button
    // private var changePlaceButton = UIButton(type: .system)
    
    init(position: Position, cat: Cat?) {
        self.position = position
        self.cat = cat
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupWindow()
        updateCatView()
        if position.isOccupied {
            setupButtons()
        } else {
            setupCatCollection()
        }
    }
    
    private func updateCatView() {
        if position.isOccupied {
            catView.addSubview(catSKView)
            catSKView.translatesAutoresizingMaskIntoConstraints = false
            catSKView.centerYAnchor.constraint(equalTo: catView.centerYAnchor).isActive = true
            catSKView.heightAnchor.constraint(equalTo: catSKView.widthAnchor).isActive = true
            catSKView.centerXAnchor.constraint(equalTo: catView.centerXAnchor).isActive = true
            catSKView.widthAnchor.constraint(equalToConstant: 0.3 * view.frame.width).isActive = true
            let size = CGSize(width: 0.3 * view.frame.width, height: 0.3 * view.frame.width)
            let kotiska = CatUnit(cat: cat ?? Cat(type: .normal), size: size)
            catSKView.presentScene(kotiska)
            catSKView.backgroundColor = .clear
            kotiska.animateCat()
        } else {
            catSKView.removeFromSuperview()
        }
    }
    
    private func setupWindow() {
        view.addSubview(setupView)
        setupView.translatesAutoresizingMaskIntoConstraints = false
        setupView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        setupView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        setupView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.4 * view.frame.width).isActive = true
        setupView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        setupView.backgroundColor = .systemGray6
        view.addSubview(catView)
        catView.translatesAutoresizingMaskIntoConstraints = false
        catView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        catView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        catView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        catView.trailingAnchor.constraint(equalTo: setupView.leadingAnchor).isActive = true
        catView.backgroundColor = .systemBackground
        let pos = UIView()
        let pretty = UIStackView(arrangedSubviews: [pos, exitButton])
        pretty.axis = .vertical
        pretty.spacing = 8
        catView.addSubview(pretty)
        pretty.translatesAutoresizingMaskIntoConstraints = false
        pretty.centerXAnchor.constraint(equalTo: catView.centerXAnchor).isActive = true
        pretty.widthAnchor.constraint(equalToConstant: 0.3 * view.frame.width).isActive = true
        pretty.topAnchor.constraint(equalTo: catView.centerYAnchor, constant: 0.05 * view.frame.width).isActive = true
        pos.heightAnchor.constraint(equalToConstant: 0.1 * view.frame.width).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        pos.layer.cornerRadius = 0.05 * view.frame.width
        pos.backgroundColor = .systemGray4
        exitButton.layer.cornerRadius = 20
        exitButton.backgroundColor = .systemGray2
        exitButton.setTitle("Return to orchestra", for: .normal)
        exitButton.setTitleColor(.label, for: .normal)
        exitButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        exitButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
    }
    
    private func setupCatCollection() {
        [changeTypeButton, changePatternButton, dismissCat].forEach {
            $0.removeFromSuperview()
        }
        setupView.addSubview(catTypes)        
        catTypes.backgroundColor = .clear
        catTypes.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        catTypes.keyboardDismissMode = .onDrag
        catTypes.dataSource = self
        catTypes.delegate = self
        catTypes.translatesAutoresizingMaskIntoConstraints = false
        catTypes.centerXAnchor.constraint(equalTo: setupView.centerXAnchor).isActive = true
        catTypes.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        catTypes.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -0.2 * view.frame.height + 30).isActive = true
        catTypes.leadingAnchor.constraint(equalTo: setupView.leadingAnchor, constant: 40).isActive = true
        
        setupView.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        saveButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -0.2 * view.frame.height + 10).isActive = true
        saveButton.leadingAnchor.constraint(equalTo: setupView.leadingAnchor, constant: 40).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: setupView.centerXAnchor).isActive = true
        saveButton.backgroundColor = .systemGray4
        saveButton.setTitle("Choose this", for: .normal)
        saveButton.layer.cornerRadius = 20
        saveButton.backgroundColor = .systemGray4
        saveButton.setTitleColor(.label, for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        saveButton.addTarget(self, action: #selector(reloadButtons), for: .touchUpInside)
    }
    
    private func setupButtons() {
        let buttonStack = UIStackView(arrangedSubviews: [changeTypeButton, changePatternButton])
        if position.isOccupied {
            buttonStack.addArrangedSubview(dismissCat)
        }
        buttonStack.axis = .vertical
        buttonStack.spacing = 0.1 * view.frame.height
        buttonStack.distribution = .fillEqually
        setupView.addSubview(buttonStack)
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.centerXAnchor.constraint(equalTo: setupView.centerXAnchor).isActive = true
        buttonStack.centerYAnchor.constraint(equalTo: setupView.centerYAnchor).isActive = true
        buttonStack.leadingAnchor.constraint(equalTo: setupView.leadingAnchor, constant: 40).isActive = true
        changePatternButton.heightAnchor.constraint(equalToConstant: 0.2 * view.frame.height).isActive = true
        changeTypeButton.setTitle("Change cat", for: .normal)
        changePatternButton.setTitle("Change sound", for: .normal)
        dismissCat.setTitle("Delete cat", for: .normal)
        [changeTypeButton, changePatternButton, dismissCat].forEach {
            $0.layer.cornerRadius = 0.1 * view.frame.height
            $0.backgroundColor = .systemGray4
            $0.setTitleColor(.label, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        }
        changeTypeButton.addTarget(self, action: #selector(openCatCollection), for: .touchUpInside)
        changePatternButton.addTarget(self, action: #selector(changePattern), for: .touchUpInside)
        dismissCat.addTarget(self, action: #selector(deleteCat), for: .touchUpInside)
    }
    
    private func updateView() {
        updateCatView()
        for sub in setupView.subviews {
            sub.removeFromSuperview()
        }
        setupButtons()
    }
    
    @objc
    private func openCatCollection(_ sender: UIButton) {
        setupCatCollection()
    }
    
    @objc
    private func changePattern(_ sender: UIButton) {
        if cat != nil {
            openMakePattern?(cat?.pattern ?? [])
        }
    }
    
    @objc
    private func deleteCat(_ sender: UIButton) {
        position.isOccupied = false
        cat = nil
        updateView()
    }
    
    @objc
    private func reloadButtons(_ sender: UIButton) {
        // MARK: как понять есть ли выбранные ячейки
        position.isOccupied = true
        updateView()
    }
    
    @objc
    private func exit(_ sender: UIButton) {
        returnToMain?(position, cat)
    }
}

extension AddCatController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return types.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let cellView = SKView(frame: cell.frame)
        let selectedView = UIView(frame: cell.frame)
        let cat = CatUnit(cat: Cat(type: types[indexPath.row]), size: cell.frame.size)
        cellView.presentScene(cat)
        cell.backgroundColor = .systemBackground
        cellView.backgroundColor = .clear
        selectedView.layer.borderColor = CGColor.init(red: 0, green: 0.5, blue: 0.5, alpha: 1)
        selectedView.layer.borderWidth = 5
        selectedView.layer.cornerRadius = 20
        cell.backgroundView = cellView
        cell.layer.cornerRadius = 20
        cell.selectedBackgroundView = selectedView
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension AddCatController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 0.13 * view.frame.width, height: 0.13 * view.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension AddCatController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let type = types[indexPath.row]
        if cat == nil {
            cat = Cat(type: type)
        } else {
            cat?.type = type
        }
    }
}
