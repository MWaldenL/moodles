import Foundation
import ReSwiftThunk
import Alamofire


extension EntryThunk {
    static func deleteEntry(entryId: String) -> Thunk<AppState> {
        return Thunk<AppState> { dispatch, getState in
            guard let state = getState() else { return }
            
            let url = "\(Api.Entry.URL_ENTRY_DELETE)/\(entryId)"
            AF.request(
                url,
                method: .delete,
                headers: ["Authorization": state.authState.token]
            ).response { res in
                let statusCode = res.response?.statusCode
                switch statusCode {
                case 200:
                    print(">>> success")
                    dispatch(TagThunk.getTagsByUserId(state.authState.userId))
                default:
                    print(">>> failure")
                }
            }
        }
    }
}
