import Foundation
import ReSwift
import ReSwiftThunk
import Alamofire


extension AuthThunk {    
    static func login(_ email: String, _ password: String) -> Thunk<AppState> {
        return authenticate(
            url: Api.Auth.URL_LOGIN,
            body: LoginBody(
                email: email,
                password: password))
    }
}
