import Foundation

final class GameName {
    private let ud = UserDefaults.standard
    var data: [GameInfo] {
        didSet {
            update()
        }
    }
    private let df: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .medium
        df.locale = Locale(identifier: "en_US_POSIX")
        return df
    }()
    
    init() {
        self.data = []
        let dataset = ud.array(forKey: "dates") ?? []
        for date in dataset {
            let d = date as? Date ?? Date.now
            let key = df.string(from: d)
            let name = ud.string(forKey: key) ?? "new game"
            self.data.append(GameInfo(name: name, date: d))
        }
    }
    
    private func update() {
        var dates: [Date] = []
        for game in data {
            dates.append(game.date)
            let key = df.string(from: game.date)
            ud.set(game.name, forKey: key)
        }
        ud.set(dates, forKey: "dates")
    }
    
    func deleteName(date: Date) {
        let key = df.string(from: date)
        ud.removeObject(forKey: key)
    }
}
