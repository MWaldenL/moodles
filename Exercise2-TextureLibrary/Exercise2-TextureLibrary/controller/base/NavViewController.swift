import UIKit
import AsyncDisplayKit
import Alamofire
import ReSwift


class NavViewController: ASDKNavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch token from cookies and set to state
        let tokenValue = TokenService.getAuthToken()
        if !tokenValue.isEmpty {
            let userId = TokenService.getUserId(fromToken: tokenValue)
            store.dispatch(AUTH_SET_TOKEN(token: tokenValue))
            store.dispatch(AUTH_SET_USERID(userId: userId))
        }
        
        let entryVC = tokenValue.isEmpty ?
            LoginViewController(node: LoginViewNode()) :
            TabBarController()
        
        self.viewControllers = [entryVC]
        self.navigationBar.isHidden = true
    }
}
