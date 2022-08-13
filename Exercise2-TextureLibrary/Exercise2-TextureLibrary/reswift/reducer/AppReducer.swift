import Foundation
import ReSwift


func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState(
        authState: authReducer(action: action, state: state?.authState),
        tagState: tagReducer(action: action, state: state?.tagState),
        entryState: entryReducer(action: action, state: state?.entryState),
        insightsState: insightsReducer(action: action, state: state?.insightsState),
        userState: userReducer(action: action, state: state?.userState)
    )
}
