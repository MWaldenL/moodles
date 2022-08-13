import Foundation
import ReSwift


//- MARK: Entry actions
struct ActionAddEntry: Action {
    var newEntry: _Entry
}

struct ActionUpdateEntry: Action {
    var updatedEntry: _Entry
}

struct ActionDeleteEntry: Action {
    var entryId: String
}

struct ActionSetEntryTimePeriod: Action {
    var timePeriod: Int
}

struct ActionResetState: Action {}

struct ActionSetStagingEntry: Action {
    var entry: Entry
}

struct ActionSetEntryId: Action {
    var id: String
}

struct ActionSetIsEditing: Action {
    var editing: Bool
}
