import Foundation
import AsyncDisplayKit
import RxSwift
import Alamofire


class AccountViewController: ASDKViewController<AccountViewNode> {
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.node.btnLogout.rxTap
            .subscribe(onNext: {
                // Clear the token both from state and session
                store.dispatch(AUTH_INVALIDATE_SESSION())
                store.dispatch(INVALIDATE_USER())
                TokenService.clearAuthToken()
                
                // Go to the login page
                self.navigationController?.viewControllers[0] =
                    LoginViewController(node: LoginViewNode())
                self.navigationController?.popToRootViewController(animated: true)
                self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
                self.tabBarController?.tabBar.isHidden = true
            })
            .disposed(by: self.disposeBag)
    }
}
