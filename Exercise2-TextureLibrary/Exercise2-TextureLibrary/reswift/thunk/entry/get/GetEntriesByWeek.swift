import Foundation
import ReSwift
import ReSwiftThunk
import Alamofire

//- MARK: Fetch entries by week
extension EntryThunk {
    static func fetchEntriesByWeek(week: Week) -> Thunk<AppState> {
        let startDay = DateService.createDate(
            year: 2022,
            month: week.month,
            day: week.startDay,
            hour: 0, minute: 0)
        
        let endDay = DateService.createDate(
            year: 2022,
            month: week.month,
            day: week.endDay + 1,
            hour: 0, minute: 0)
        
        return getEntries(
            by: .week,
            startDay: startDay,
            endDay: endDay)
    }
}
