import Foundation
import ReSwift


func entryReducer(action: Action, state: EntryState?) -> EntryState {
    var entryState = state ?? EntryState()
    
    switch action {
        
//- MARK: CRUD methods
    case let action as ActionSetCurrentEntries:
        entryState.originalEntries = action.currentEntries.sorted(by: {
            $0.dateCreated > $1.dateCreated
        })
        
    case let action as ActionSetEntryTags:
        let entryId = action.forEntryId
        if let i = entryState.originalEntries.firstIndex(where: { $0.id == entryId }) {
            entryState.originalEntries[i].tags = action.tagList
        }
        entryState._entries = refreshEntryList(entryState)
        
    case let action as ActionAddEntry:
        entryState.originalEntries.append(action.newEntry)
        entryState.originalEntries = entryState.originalEntries.sorted(by: {
            $0.dateCreated > $1.dateCreated
        })
        entryState._entries = refreshEntryList(entryState)
        
    case let action as ActionUpdateEntry:
        let entries = entryState._entries
        if let ind = entries.firstIndex(where: { $0.id == entryState.currentEntryId }) {
            entryState.originalEntries[ind] = action.updatedEntry
        } else {
            print(">>> No entry found")
        }
        entryState._entries = refreshEntryList(entryState)
        
    case let action as ActionDeleteEntry:
        entryState.originalEntries.removeAll(where: { $0.id == action.entryId })
        entryState._entries = refreshEntryList(entryState)
        
    case let action as ActionSetEntryTimePeriod:
        entryState.currentEntryTimePeriod = action.timePeriod
        
//- MARK: Editing entries
    case let action as ActionSetEntryId:
        entryState.currentEntryId = action.id
        
        // Set the new entry request
        if let currentEntry = entryState._entries.first(where: { $0.id == action.id }) {
            entryState.newEntryRequest = EntryRequest(
                id: currentEntry.id,
                date: currentEntry.dateCreated,
                moodLevel: Float(currentEntry.moodLevel),
                note: currentEntry.note,
                tags: Set(currentEntry.tags.map { tag in
                    TagRequest(tagName: tag.tagName, fromUserTags: true)
                })
            )
        }
        
        
//- MARK: New entry
    case let action as ActionSetNewEntryMood:
        entryState.newEntryRequest.moodLevel = action.mood
        
    case let action as ActionSetNewEntryDate:
        entryState.newEntryRequest.date = action.date
        
    case let action as ActionAddTag:
        entryState.newEntryRequest.tags.insert(action.tag)
        
    case let action as ActionSelectTag:
        // remove from removed tags only if it is there
        if entryState.newEntryRequest.removedTags.contains(action.tag) {
            entryState.newEntryRequest.removedTags.remove(action.tag)
        }
        entryState.newEntryRequest.tags.insert(action.tag)
        
    case let action as ActionDeselectTag:
        entryState.newEntryRequest.tags.remove(action.tag)
        entryState.newEntryRequest.removedTags.insert(action.tag)
        
    case let action as ActionAddNote:
        entryState.newEntryRequest.note = action.note
        
    case _ as ActionResetState:
        entryState.newEntryRequest = EntryRequest()
        entryState.currentEntryId = ""
        
        // Show list based on selected time period
        entryState._entries = refreshEntryList(entryState)
        
        
//- MARK: Filtering entries
    case let action as ActionSetCurrentDay:
        entryState.currentDay = action.day
        
    case let action as ActionSetCurrentWeek:
        entryState.currentWeek = action.week
        
    case let action as ActionSetCurrentMonth:
        entryState.currentMonth = action.month
        
    case let action as ActionFilterByDay:
        entryState.currentDay = action.day
        entryState._entries = filterByDay(
            withList: entryState.originalEntries,
            by: action.day)
        
    case let action as ActionFilterByMonth:
        entryState.currentMonth = action.monthIndex
        entryState._entries = filterByMonth(
            withList: entryState.originalEntries,
            by: entryState.currentMonth)
        
    case let action as ActionFilterByWeek:
        entryState.currentWeek = action.week
        entryState._entries = filterByWeek(
            withList: entryState.originalEntries,
            by: entryState.currentWeek)
        
    default:
        break
    }
    
    return entryState
}

func refreshEntryList(_ entryState: EntryState) -> [_Entry] {
    // Show list based on selected time period
    switch entryState.currentEntryTimePeriod {
    case 0: // Day
        return filterByDay(
            withList: entryState.originalEntries,
            by: entryState.currentDay)
        
    case 1: // Week
        return filterByWeek(
            withList: entryState.originalEntries,
            by: entryState.currentWeek)
            
    case 2: // Month
        return filterByMonth(
            withList: entryState.originalEntries,
            by: entryState.currentMonth)
            
    default: // All
        return filterByAll(
            withList: entryState.originalEntries)
    }
}

func filterByDay(withList entryList: [_Entry], by day: Date) -> [_Entry] {
    let L = entryList
        .filter { entry in
            return DateService.day(entry.dateCreated) == DateService.day(day)
        }
        .sorted(by: { $0.dateCreated > $1.dateCreated })
    return L
}

func filterByWeek(withList entryList: [_Entry], by week: Week) -> [_Entry] {
    return entryList
        .filter { entry in
            return DateService.month(entry.dateCreated) == week.month &&
                DateService.dayNum(entry.dateCreated) >= week.startDay &&
                DateService.dayNum(entry.dateCreated) <= week.endDay
        }
        .sorted(by: { $0.dateCreated > $1.dateCreated })
}

func filterByMonth(withList entryList: [_Entry], by month: Int) -> [_Entry] {
    return entryList
        .filter { entry in
            DateService.month(entry.dateCreated) == month
        }
        .sorted(by: { $0.dateCreated > $1.dateCreated })
}

func filterByAll(withList entryList: [_Entry]) -> [_Entry] {
    return entryList
        .sorted(by: { $0.dateCreated > $1.dateCreated })
}
