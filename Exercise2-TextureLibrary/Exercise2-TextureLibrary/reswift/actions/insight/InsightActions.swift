import Foundation
import ReSwift


//- MARK: Insight Actions
struct ActionSetInsightTags: Action {
    var tagSet: Set<Tag>
}

struct ActionSetCurrentInsightPeriod: Action {
    var selectedInsightPeriod: Int
}

struct ActionSetInsightsLoaded: Action {
    
}

struct ActionFilterInsightTagsByWeek: Action {
    var week: Week
}

struct ActionFilterInsightTagsByMonth: Action {
    var month: Int
}

struct ActionFilterInsightTagsAll: Action {}

struct ActionFilterByMoodLevel: Action {
    var moodLevel: Float
}

