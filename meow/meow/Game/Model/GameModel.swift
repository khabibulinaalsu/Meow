import Foundation

enum catType: String {
    case normal
    case loud
    // MARK: добавить когда нибудь
/*
    case sleepy
    case kitty
    case drum
    case scrape
 */
}

struct Cat {
    var pattern: [Int]
    var type: catType
    
    init(type: catType) {
        self.pattern = []
        self.type = type
    }
}

struct GameInfo {
    var name: String = "new game"
    var date: Date = Date.now
}
