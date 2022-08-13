import Foundation
import ReSwiftThunk
import Alamofire

struct AuthThunk {
    static func authenticate<T: Encodable>(url: String, body: T) -> Thunk<AppState> {
        return Thunk<AppState> { dispatch, getState in            
            AF.request(
                url,
                method: .post,
                parameters: body,
                encoder: JSONParameterEncoder.default
            ).responseData { res in
                    let statusCode = res.response?.statusCode
                    switch statusCode {
                    case 200:
                        if let data = res.data {
                            do {
                                let rawResponse = try JSONDecoder().decode(AuthSuccessResponse.self, from: data)
                                let token = rawResponse.token
                                let userId = rawResponse.userId
                                
                                // Set token to cookies and store
                                TokenService.writeTokenToCookies(token: token)
                                dispatch(AUTH_SET_TOKEN(token: token))
                                dispatch(AUTH_SET_USERID(userId: userId))
                            } catch(let err) {
                                print(err)
                            }
                        }
                    default:
                        dispatch(AUTH_FAIL_AUTH(failed: true))
                        print("failure")
                    }
                }
        }
    }
}
