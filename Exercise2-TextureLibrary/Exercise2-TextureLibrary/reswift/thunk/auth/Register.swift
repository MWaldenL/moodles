import Foundation
import ReSwift
import ReSwiftThunk
import Alamofire


extension AuthThunk {
    static func register(email: String, password: String, confirmPassword: String, name: String) -> Thunk<AppState> {
        return authenticate(
            url: Api.Auth.URL_REGISTER,
            body: RegisterBody(
                email: email,
                name: name,
                password: password,
                confirmPassword: confirmPassword))
    }
}
