import Foundation
import AsyncDisplayKit


class LoginViewNode: ASDisplayNode {
    let imgLogo = ASImageNode()
    let inputEmail = FormInputField(
        label: "Email",
        placeholder: "Email")
    
    let inputPassword = FormInputField(
        label: "Password",
        placeholder: "Password",
        isPassword: true)
    
    let btnRegister = ButtonLinkLight(name: "Create an account")
    let btnLogin = ButtonDark(name: "Login")
    let errLogin = TextError(label: "Email or password is incorrect.")
    
    var formStack: [ASLayoutElement] = []
    var authFailed = false
    
    override init() {
        super.init()
        backgroundColor = Styles.Color.primary
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        imgLogo.image = UIImage(systemName: "note.text")?
            .withTintColor(.white, renderingMode: .alwaysTemplate)
        imgLogo.tintColor = .white
        imgLogo.style.height = Styles.Dimens._60
        imgLogo.style.width = Styles.Dimens._60
    }
    
    func showErrors() {
        self.authFailed = true
        self.setNeedsLayout()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let viewLogo = ASCenterLayoutSpec(
            centeringOptions: .XY,
            sizingOptions: [],
            child: imgLogo)
        
        let viewBtnLogin = ASInsetLayoutSpec(
            insets: .init(top: 10, left: 50, bottom: 10, right: 50),
            child: btnLogin)
        
        let stackFields = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 20,
            justifyContent: .start,
            alignItems: .stretch,
            flexWrap: .wrap,
            alignContent: .stretch,
            lineSpacing: 20,
            children: [inputEmail, inputPassword, viewBtnLogin])
        
        let viewError = ASCenterLayoutSpec(
            centeringOptions: .XY,
            sizingOptions: [],
            child: errLogin)
        
        let viewRegister = ASInsetLayoutSpec(
            insets: .init(top: 10, left: 50, bottom: 10, right: 50),
            child: btnRegister)
        
        self.formStack = [viewLogo, stackFields, viewRegister]
        if authFailed {
            self.formStack.insert(viewError, at: 1)
        }
        
        let stackParent = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 20,
            justifyContent: .center,
            alignItems: .stretch,
            flexWrap: .wrap,
            alignContent: .stretch,
            lineSpacing: 20,
            children: formStack)
        
        let container = ASInsetLayoutSpec(
            insets: .init(top: 10, left: 10, bottom: 10, right: 10),
            child: stackParent)
        
        return container
    }
}
