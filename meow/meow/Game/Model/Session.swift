import Foundation

final class Session {
    private let ud = UserDefaults.standard
    private let df: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .medium
        df.locale = Locale(identifier: "en_US_POSIX")
        return df
    }()
    private let date: Date
    
    var curSes: [Int:Cat] {
        didSet {
            update()
        }
    }
    let rows: Int
    let cols: Int
    var num: Int {
        rows * cols
    }
    
    init(date: Date) {
        self.date = date
        self.curSes = [:]
        let keyRows = df.string(from: date) + "rows"
        let keyCols = df.string(from: date) + "cols"
        self.rows = ud.integer(forKey: keyRows)
        self.cols = ud.integer(forKey: keyCols)
        for i in 1...num {
            let keyType = df.string(from: date) + "\(i)type"
            if let type = ud.string(forKey: keyType) {
                var cat = Cat(type: catType.init(rawValue: type) ?? .normal)
                let keyPattern = df.string(from: date) + "\(i)pattern"
                let array = ud.array(forKey: keyPattern) ?? []
                cat.pattern = []
                for note in array {
                    let int: Int = note as? Int ?? 0
                    cat.pattern.append(int)
                }
                curSes[i] = cat
            }
        }
    }
    
    init(date: Date, rows: Int, cols: Int) {
        self.date = date
        self.curSes = [:]
        self.rows = rows
        self.cols = cols
        let keyRows = df.string(from: date) + "rows"
        let keyCols = df.string(from: date) + "cols"
        ud.set(self.rows, forKey: keyRows)
        ud.set(self.cols, forKey: keyCols)
    }
    
    private func update() {
        for (k, cat) in curSes {
            let keyType = df.string(from: date) + "\(k)type"
            let keyPattern = df.string(from: date) + "\(k)pattern"
            ud.set(cat.type.rawValue, forKey: keyType)
            ud.set(cat.pattern, forKey: keyPattern)
        }
    }
    
    func deleteCat(number: Int) {
        curSes[number] = nil
        let keyType = df.string(from: date) + "\(number)type"
        let keyPattern = df.string(from: date) + "\(number)pattern"
        ud.removeObject(forKey: keyType)
        ud.removeObject(forKey: keyPattern)
    }
    
    func updateCat(num: Int, for cat: Cat?) {
        if cat != nil {
            curSes[num] = cat
        } else {
            deleteCat(number: num)
        }
    }
}
