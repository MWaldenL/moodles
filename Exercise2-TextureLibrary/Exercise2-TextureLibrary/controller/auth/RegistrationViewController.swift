import Foundation
import AsyncDisplayKit
import ReSwift
import RxSwift
import Alamofire


class RegistrationViewController: BaseAuthViewController {
    var registrationNode: RegistrationViewNode!
    
    override init(node: ASDisplayNode) {
        super.init(node: RegistrationViewNode())
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.registrationNode = self.node as? RegistrationViewNode
        self.registrationNode.btnRegister.rxTap
            .subscribe(onNext: {
                // Frontend validation
                let fields = [
                    "name": self.registrationNode.inputName.fieldText,
                    "email": self.registrationNode.inputEmail.fieldText,
                    "password": self.registrationNode.inputPassword.fieldText,
                    "confirmPassword": self.registrationNode.inputPasswordConfirm.fieldText
                ]
                let errorMessages = ValidationService.validate(fields: fields)
                if errorMessages.isEmpty {
                    store.dispatch(
                        AuthThunk.register(
                            email: fields["email"]!,
                            password: fields["password"]!,
                            confirmPassword: fields["confirmPassword"]!,
                            name: fields["name"]!))
                } else {
                    self.registrationNode.showErrors(msgs: errorMessages.map { $0.value })
                    self.registrationNode.setNeedsLayout()
                }
            })
            .disposed(by: self.disposeBag)
        
        self.registrationNode.btnLogin.rxTap
            .subscribe(onNext: {
                self.navigationController?.pushViewController(
                    LoginViewController(node: LoginViewNode()),
                    animated: true)
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
        self.registrationNode.showErrors(msgs: ["Oops! We're sorry. Please try again later."])
    }
}
