import Foundation
import ReSwift


//- MARK: Filtering Actions
struct ActionSetCurrentEntries: Action {
    var currentEntries: [_Entry]
}

struct ActionSetCurrentDay: Action {
    var day: Date
}

struct ActionSetCurrentWeek: Action {
    var week: Week
}

struct ActionSetCurrentMonth: Action {
    var month: Int
}

struct ActionFilterByDay: Action {
    var day: Date
}

struct ActionFilterByWeek: Action {
    var week: Week
}

struct ActionFilterByMonth: Action {
    var monthIndex: Int
}

struct ActionFilterAll: Action {}

