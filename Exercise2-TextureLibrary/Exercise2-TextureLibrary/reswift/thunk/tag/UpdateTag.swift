import Foundation
import ReSwiftThunk
import Alamofire


extension TagThunk {
    static func updateTag(oldName: String, newName: String) -> Thunk<AppState> {
        return Thunk<AppState> { dispatch, getState in
            guard let state = getState() else { return }
            
            let url = "\(Api.BASE_URL)/tags/\(oldName)"
            let rawTagRequest = RawTagUpdateReq(name: newName)
            
            AF.request(
                url,
                method: .put,
                parameters: rawTagRequest,
                headers: ["Authorization": state.authState.token]
            ).response { res in
                let statusCode = res.response?.statusCode
                switch statusCode {
                case 200:
                    print(">>> success")
                default:
                    print(">>> failure")
                }
            }
        }
    }
}
