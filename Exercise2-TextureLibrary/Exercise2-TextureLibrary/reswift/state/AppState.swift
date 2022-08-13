import Foundation
import ReSwift
import ReSwiftThunk

struct AppState {
    var authState = AuthState()
    var tagState = TagState()
    var entryState = EntryState()
    var insightsState = InsightsState()
    var userState = UserState()
}

let thunkMiddleware: Middleware<AppState> = createThunkMiddleware()
let store = Store<AppState>.init(
    reducer: appReducer,
    state: AppState(),
    middleware: [thunkMiddleware]
)
