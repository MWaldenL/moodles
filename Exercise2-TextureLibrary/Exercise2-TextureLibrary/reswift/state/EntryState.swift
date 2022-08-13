import Foundation


struct EntryState {
    // Entry list view
    var originalEntries: [_Entry] = []
    var _entries: [_Entry] = []
    
    // Create/update entry
    var newEntryRequest: EntryRequest = EntryRequest()
    var isEditingEntry: Bool { get { !currentEntryId.isEmpty } }
    var currentEntryId: String = ""
    
    // Selector view
    var currentEntryTimePeriod: Int = 0
    var currentWeek: Week = DateService.getCurrentWeek()
    var currentMonth: Int = DateService.getCurrentMonth()
    var currentDay: Date = Date()
}
