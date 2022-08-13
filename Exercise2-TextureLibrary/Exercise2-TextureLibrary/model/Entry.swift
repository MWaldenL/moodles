import Foundation


struct EntryRequest {
    var id: String = UUID().uuidString
    var date: Date = Date()
    var moodLevel: Float = 0
    var note: String = ""
    var tags: Set<TagRequest> = []
    var removedTags: Set<TagRequest> = []
}

struct _Entry {
    var id: String = UUID().uuidString
    var dateCreated: Date = Date()
    var dateUpdated: Date = Date()
    var moodLevel: Int = 0
    var note: String = ""
    var tags: Set<TagEntry> = []
}

enum EntryTimePeriod {
    case day, week, month, all
}























// OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD
struct Entry { // OLD OLD OLD!!!
    var id: String = UUID().uuidString
    var date: Date = Date()
    var moodLevel: Float = 0
    var note: String = ""
    var tags: Set<Tag> = []
    struct Tag: Hashable {
        var name: String = ""
        var selected: Bool = false
    }
}
// OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD
