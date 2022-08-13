import Foundation
import ReSwift


func authReducer(action: Action, state: AuthState?) -> AuthState {
    var authState = state ?? AuthState()
    
    switch action {
        
    case let action as AUTH_SET_TOKEN:
        authState.token = action.token
        
    case let action as AUTH_SET_USERID:
        authState.userId = action.userId
        
    case let action as AUTH_FAIL_AUTH:
        authState.failed = action.failed
        
    case _ as AUTH_INVALIDATE_SESSION:
        authState.userId = ""
        authState.token = ""
        
    default:
        break
    }
    
    return authState
}
