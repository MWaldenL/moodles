import Foundation
import ReSwift


struct ActionCreateNewTag: Action {
    var name: String
}

struct ActionUpdateTag: Action {
    var oldName: String
    var newName: String
}

struct ActionDeleteTag: Action {
    var name: String
}

struct ActionSetEntryTags: Action {
    var forEntryId: String
    var tagList: Set<TagEntry>
}

struct ActionSetAllTags: Action {
    var tagSet: Set<Tag>
}

struct ActionMergeToAllTags: Action {
    var tagSet: Set<Tag>
}

struct ActionMergeUserTagRequests: Action {
    var tagSet: Set<TagRequest>
}
