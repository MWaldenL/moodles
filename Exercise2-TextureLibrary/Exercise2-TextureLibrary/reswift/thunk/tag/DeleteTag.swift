import Foundation
import ReSwiftThunk
import Alamofire


extension TagThunk {
    static func deleteTag(name: String) -> Thunk<AppState> {
        return Thunk<AppState> { dispatch, getState in
            guard let state = getState() else { return }
            
            let url = "\(Api.BASE_URL)/tags/\(name)"
            AF.request(
                url,
                method: .delete,
                headers: ["Authorization": state.authState.token]
            ).response { res in
                let statusCode = res.response?.statusCode
                switch statusCode {
                case 200:
                    print(">>> TagThunk.deleteTag: success")
                default:
                    print(">>> TagThunk.deleteTag: failure")
                }
            }
        }
    }
}
