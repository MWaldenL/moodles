import Foundation
import ReSwift


struct AUTH_SET_TOKEN: Action {
    var token: String
}

struct AUTH_SET_USERID: Action {
    var userId: String
}

struct AUTH_FAIL_AUTH: Action {
    var failed: Bool
}

struct AUTH_INVALIDATE_SESSION: Action {}
