import Foundation

final class Router {
    
    private let rootViewController: RootViewController
    private var loadController = LoadGameController(dataSource: GameName())
    private var currentCat: AddCatController?
    private var game: GameController? {
        didSet {
            setupButtons()
        }
    }
    
    init(rootViewController: RootViewController) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        toLoadView()
    }
    
    private func toLoadView() {
        self.loadController.toNameGame = { [weak self] in
            self?.toNameGame()
        }
        self.loadController.toGame = { [weak self] dateGame in
            self?.toGame(date: dateGame)
        }
        self.rootViewController.pushViewController(loadController, animated: true)
    }
    
    private func toNameGame() {
        let nameGameController = NameGameController()
        nameGameController.addGame = { [weak self] name, rows, cols in
            let date = Date.now
            self?.loadController.addGame(name: name, date: date)
            self?.rootViewController.popViewController(animated: false)
            self?.toNewGame(date: date, rows: rows, cols: cols)
        }
        self.rootViewController.pushViewController(nameGameController, animated: true)
    }
    
    private func toGame(date: Date) {
        game = GameController(session: Session(date: date))
        if let game = game {
            self.rootViewController.pushViewController(game, animated: true)
        }
    }
    
    private func toNewGame(date: Date, rows: Int, cols: Int) {
        game = GameController(session: Session(date: date, rows: rows, cols: cols))
        if let game = game {
            self.rootViewController.pushViewController(game, animated: true)
        }
    }
    private func setupButtons() {
        game?.changeCat = { [weak self] position, cat in
            self?.changeCat(position: position, cat: cat)
        }
    }
    
    private func changeCat(position: Position, cat: Cat?) {
        self.currentCat = AddCatController(position: position, cat: cat)
        if let cc = self.currentCat {
            cc.returnToMain = { [weak self] position, cat in
                self?.game?.session.updateCat(num: position.num, for: cat)
                self?.game?.setupCurrentPosition(position.num)
                self?.rootViewController.popViewController(animated: true)
                //self?.game?.runAudio()
            }
            cc.openMakePattern = { [weak self] pattern in
                self?.toMakePattern(position: position.num, pattern: pattern)
            }
            self.rootViewController.pushViewController(cc, animated: true)
        }
    }
    
    private func toMakePattern(position: Int, pattern: [Int]) {
        let controller = MakePatternController(pattern: pattern)
        controller.save = { [weak self] patt in
            self?.currentCat?.cat?.pattern = patt
            self?.rootViewController.popViewController(animated: true)
        }
        self.rootViewController.pushViewController(controller, animated: true)
    }
}
