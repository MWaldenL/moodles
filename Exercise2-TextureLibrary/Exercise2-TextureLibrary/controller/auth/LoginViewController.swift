import Foundation
import AsyncDisplayKit
import RxSwift
import Alamofire
import ReSwift


class LoginViewController: BaseAuthViewController {
    var loginNode: LoginViewNode!
    
    override init(node: ASDisplayNode) {
        super.init(node: LoginViewNode())
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
        
        self.navigationController?.navigationBar.isHidden = true
        self.loginNode = self.node as? LoginViewNode
        
        self.loginNode.btnRegister.rxTap
            .subscribe(onNext: {
                self.navigationController?.pushViewController(
                    RegistrationViewController(node: RegistrationViewNode()),
                    animated: true)
            })
            .disposed(by: self.disposeBag)
        
        self.loginNode.btnLogin.rxTap
            .subscribe(onNext: {
                let email = self.loginNode.inputEmail.fieldText
                let password = self.loginNode.inputPassword.fieldText
                store.dispatch(AuthThunk.login(email, password))
            })
            .disposed(by: self.disposeBag)
    }
    
    override func onAuthSuccess() {
        (UIApplication.shared
            .connectedScenes
            .first?
            .delegate as? SceneDelegate)?
            .changeRootViewController(TabBarController())
    }
    
    override func onAuthError() {
        self.loginNode.showErrors()
    }
}
