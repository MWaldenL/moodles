import Foundation
import ReSwift
import ReSwiftThunk
import Alamofire


extension EntryThunk {
    static func getAllEntries() -> Thunk<AppState> {
        return getEntries(by: .all, startDay: nil, endDay: nil)
    }
}
