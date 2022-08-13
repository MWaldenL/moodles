import Foundation
import ReSwift


func insightsReducer(action: Action, state: InsightsState?) -> InsightsState {
    var insightsState = state ?? InsightsState()
    
    switch action {
    case let action as ActionSetInsightTags:
        insightsState.allTags = action.tagSet
        
    case let action as ActionSetCurrentInsightPeriod:
        insightsState.currentInsightPeriod = action.selectedInsightPeriod
        insightsState.currentTagsByMood = filterByMood(
            insightsState: insightsState,
            moodLevel: insightsState.currentMoodLevel)
        
    case let action as ActionFilterInsightTagsByWeek:
        let month = action.week.month
        let startDay = action.week.startDay
        let endDay = action.week.endDay
        
        insightsState.currentTags = insightsState.allTags.filter { tag in
            let tagDatesByWeek = tag.datesLogged.filter { date in
                return DateService.month(date) == month &&
                    DateService.dayNum(date) >= startDay &&
                    DateService.dayNum(date) <= endDay
            }
            return !tagDatesByWeek.isEmpty
        }
        
    case let action as ActionFilterInsightTagsByMonth:
        insightsState.currentTags = insightsState.allTags.filter { tag in
            let tagDatesByMonth = tag.datesLogged.filter {
                DateService.month($0) == action.month
            }
            return !tagDatesByMonth.isEmpty
        }
        
    case _ as ActionFilterInsightTagsAll:
        insightsState.currentTags = insightsState.allTags
        
    case let action as ActionFilterByMoodLevel:
        insightsState.currentMoodLevel = action.moodLevel
        insightsState.currentTagsByMood = filterByMood(
            insightsState: insightsState,
            moodLevel: action.moodLevel)
        
    default:
        break
    }
    
    return insightsState
}

func filterByMood(insightsState: InsightsState, moodLevel: Float) -> Set<Tag> {
    print(">>> InsightsReducer", insightsState.currentTags.map { $0.tagName })
    let currentTagsByMood = insightsState.currentTags
        .filter { tag in
            tag.entryIdSet.contains(where: { entry in
                entry.value == moodLevel
            })
        }
    
    var tagsArr = Array(currentTagsByMood)
    for (i, _) in tagsArr.enumerated() {
        tagsArr[i].entryIdSet = tagsArr[i].entryIdSet.filter { entry in
            entry.value == moodLevel
        }
    }
    return Set(tagsArr)
}
