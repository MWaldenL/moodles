import Foundation
import AsyncDisplayKit
import ReSwift
import RxSwift


protocol AuthDelegate: AnyObject {
    func onAuthSuccess()
    func onAuthError()
}

class BaseAuthViewController: ASDKViewController<ASDisplayNode>, StoreSubscriber {
    typealias StoreSubscriberStateType = AppState
    let disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }
    
    func newState(state: StoreSubscriberStateType) {
        if !state.authState.token.isEmpty {
            self.onAuthSuccess()
        } else if state.authState.failed {
            self.onAuthError()
        }
    }
    
    func onAuthSuccess() {
        preconditionFailure("Method must be overriden")
    }
    
    func onAuthError() {
        preconditionFailure("Method must be overriden")
    }
}
