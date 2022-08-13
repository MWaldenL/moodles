import Foundation
import ReSwift

struct Api {
    static let BASE_URL = "http://localhost:8000"
    
    struct Auth {
        static let URL_AUTH_BASE = "\(BASE_URL)/auth"
        static let URL_LOGIN = "\(URL_AUTH_BASE)/login"
        static let URL_REGISTER = "\(URL_AUTH_BASE)/register"
    }
    
    struct User {
        static let URL_USER_BASE = "\(BASE_URL)/users"
    }
    
    struct Entry {
        static let URL_ENTRY_BASE = "\(BASE_URL)/entries"
        static let URL_ENTRY_USER = "\(URL_ENTRY_BASE)/\(store.state.authState.userId)"
        static let URL_ENTRY_DELETE = "\(URL_ENTRY_BASE)/"
    }
}
