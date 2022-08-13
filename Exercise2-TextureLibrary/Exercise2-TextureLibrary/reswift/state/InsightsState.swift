import Foundation


struct InsightsState {
    var allTags: Set<Tag> = []
    var currentTags: Set<Tag> = []
    var currentTagsByMood: Set<Tag> = []
    var currentInsightPeriod: Int = 0
    var insightsToggle = false
    
    var currentMoodLevel: Float = 3
    var currentEntryTimePeriod: Int = 0
    var insightEntries: [Entry] = []
    var insightEntriesByMood: [Entry] = []
}
