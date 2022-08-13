import Foundation
import ReSwift


func userReducer(action: Action, state: UserState?) -> UserState {
    var userState = state ?? UserState()
    
    switch action {
        
    case let action as SET_USER:
        userState.currentUser = action.user
        
    case _ as INVALIDATE_USER:
        userState.currentUser = User(id: "", email: "", name: "")
        
    default:
        break
        
    }
    
    return userState
}
