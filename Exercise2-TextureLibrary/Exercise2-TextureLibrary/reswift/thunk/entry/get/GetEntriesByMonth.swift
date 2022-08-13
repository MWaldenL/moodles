import Foundation
import ReSwift
import ReSwiftThunk
import Alamofire


extension EntryThunk {
    static func fetchEntriesByMonth(month: Int) -> Thunk<AppState> {
        // UI update
        store.dispatch(
            ActionFilterByMonth(monthIndex: month))
        
        let startDay = DateService.createDate(
            year: 2022,
            month: month,
            day: 1,
            hour: 0, minute: 0)
        
        let endDay = DateService.createDate(
            year: 2022,
            month: month + 1,
            day: 1,
            hour: 0, minute: 0)
        
        store.dispatch(
            ActionFilterByMonth(
                monthIndex: month))
        
        return getEntries(
            by: .month,
            startDay: startDay,
            endDay: endDay)
    }
}
