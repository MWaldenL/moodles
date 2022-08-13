import Foundation
import ReSwift


struct ActionSetNewEntryMood: Action {
    var mood: Float
}

struct ActionSetNewEntryDate: Action {
    var date: Date
}

struct ActionSetNewEntryNote: Action {
    var note: String
}

struct ActionAddTag: Action {
    var tag: TagRequest
}

struct ActionSelectTag: Action {
    var tag: TagRequest
}

struct ActionDeselectTag: Action {
    var tag: TagRequest
}

struct ActionAddNote: Action {
    var note: String
}
