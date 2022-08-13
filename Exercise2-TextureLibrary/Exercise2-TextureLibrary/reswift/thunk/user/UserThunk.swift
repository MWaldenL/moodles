import Foundation
import ReSwiftThunk
import Alamofire

struct UserThunk {
    static func getCurrentUser() -> Thunk<AppState> {
        return Thunk<AppState> { dispatch, getState in
            guard let state = getState() else { return }
        
            let url = "http://localhost:8000/users/\(state.authState.userId)"
            AF.request(
                url,
                method: .get,
                headers: ["Authorization": state.authState.token]
            ).response { res in 
                let statusCode = res.response?.statusCode
                switch statusCode {
                case 200:
                    if let data = res.data {
                        do {
                            let rawResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                            let user = User(
                                id: rawResponse._id,
                                email: rawResponse.email,
                                name: rawResponse.name
                            )
                            print(">>> ", user)
                            dispatch(
                                SET_USER(
                                    user: user))
                        } catch (let error) {
                            print(error)
                        }
                    } else {
                        print(">>> no user")
                    }
                default:
                    print(">>> failure")
                }
            }
            
        }
    }
}
