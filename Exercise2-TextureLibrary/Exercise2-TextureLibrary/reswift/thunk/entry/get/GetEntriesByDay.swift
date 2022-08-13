import Foundation
import ReSwift
import ReSwiftThunk
import Alamofire


//- MARK: Get entries by day
extension EntryThunk {
    static func fetchEntriesByDay(day: Date) -> Thunk<AppState> {
        // UI update
        store.dispatch(
            ActionFilterByDay(day: day))
        
        return getEntries(
            by: .day,
            startDay: day,
            endDay: day)
    }
}
