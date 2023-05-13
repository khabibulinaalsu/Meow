import UIKit

final class LoadGameController: UIViewController {
    // TODO: наладить выкачивание датасорса
    private var tableView = UITableView(frame: .zero)
    private var dataSource: GameName
    var toNameGame: (() -> Void)?
    var toGame: ((Date) -> Void)?
    
    init(dataSource: GameName) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
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
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.register(NewGameCell.self, forCellReuseIdentifier: NewGameCell.reuseIdentifier)
        tableView.register(LoadCell.self, forCellReuseIdentifier: LoadCell.reuseIdentifier)
        tableView.keyboardDismissMode = .onDrag
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }

    func addGame(name: String, date: Date) {
        dataSource.data.append(GameInfo(name: name, date: date))
        tableView.reloadData()
    }
}

extension LoadGameController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            /*
            if dataSource.data.count > 10 {
                return 0
            }
             */
            return 1
        default:
            return dataSource.data.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let addNewCell = tableView.dequeueReusableCell(withIdentifier: NewGameCell.reuseIdentifier, for: indexPath) as? NewGameCell {
                addNewCell.click = toNameGame
                return addNewCell
            }
        default:
            let note = dataSource.data[indexPath.row]
            if let noteCell = tableView.dequeueReusableCell(withIdentifier: LoadCell.reuseIdentifier, for: indexPath) as? LoadCell {
                noteCell.configure(note)
                noteCell.click = toGame
                return noteCell
            }
        }
        return UITableViewCell()
    }
}

extension LoadGameController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 80
    }
    
    private func handleDelete(indexPath: IndexPath) {
        if indexPath.section != 0 {
            let date = dataSource.data[indexPath.row].date
            dataSource.deleteName(date: date)
            dataSource.data.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
        
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 0 {
            return nil
        }
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: .none
        ) { [weak self] (action, view, completion) in self?.handleDelete(indexPath: indexPath)
            completion(true)
        }
        deleteAction.image = UIImage(
            systemName: "trash.fill",
            withConfiguration: UIImage.SymbolConfiguration(weight: .bold)
        )?.withTintColor(.white)
        deleteAction.backgroundColor = UIColor(red: 1, green: 0.0, blue: 0.0, alpha: 1)
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
