import Foundation


struct Tag: Hashable {
    var id: String = ""
    var userId: String = ""
    var entryIdSet: [String: Float] = [:]
    var tagName: String = ""
    var datesLogged: [Date] = []
    var selected: Bool = false
}

struct TagRequest: Hashable {
    var tagName: String = ""
    var oldTagName: String?
    var fromUserTags: Bool = false
}

struct TagEntry: Hashable {
    var tagName: String = ""
}
