import Foundation
import AsyncDisplayKit


class RegistrationViewNode: ASDisplayNode {
    let labelTitle = TextHeaderLight(label: "Register")
    
    let inputName = FormInputField(
        label: "Name",
        placeholder: "Name")
    
    let inputEmail = FormInputField(
        label: "Email",
        placeholder: "Email")
    
    let inputPassword = FormInputField(
        label: "Password",
        placeholder: "Password",
        isPassword: true)
    
    let inputPasswordConfirm = FormInputField(
        label: "Confirm Password",
        placeholder: "Confirm Password",
        isPassword: true)
    
    let btnRegister = ButtonDark(name: "Register")
    let btnLogin = ButtonLinkLight(name: "Have an account? Log in here")
    
    let errText = TextError()
    var errorList: [TextError] = []
    
    let scroll = ASScrollNode()
    
    override init() {
        super.init()
        backgroundColor = Styles.Color.primary
        automaticallyManagesSubnodes = true
    }
    
    func showErrors(msgs: [String]) {
        self.errorList = msgs.map { msg -> TextError in
            let textErr = TextError(label: msg)
            return textErr
        }
        self.setNeedsLayout()
    }
    
    func showError(msg: String) {
        errText.style.height = Styles.Dimens._60
        errText.label = msg
        self.setNeedsLayout()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        print(">>> RegViewNode.getScrollLayout called ")
        let viewTitle = ASInsetLayoutSpec(
            insets: .init(top: 10, left: 10, bottom: 10, right: 10),
            child: labelTitle)
        
        let stackErr =  ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .center,
            alignItems: .stretch,
            flexWrap: .wrap,
            alignContent: .stretch,
            children: self.errorList)
        
        let viewErrors = ASInsetLayoutSpec(
            insets: .init(top: 10, left: 10, bottom: 10, right: 10),
            child: stackErr)
        
        let viewBtnRegister = ASInsetLayoutSpec(
            insets: .init(top: 10, left: 50, bottom: 10, right: 50),
            child: btnRegister)
        
        let viewBtnHave = ASInsetLayoutSpec(
            insets: .init(top: 10, left: 50, bottom: 10, right: 50),
            child: btnLogin)
        
        let stackFields = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .center,
            alignItems: .stretch,
            flexWrap: .wrap,
            alignContent: .stretch,
            lineSpacing: 20,
            children: [
                viewTitle, viewErrors,
                inputName, inputEmail, inputPassword, inputPasswordConfirm,
                viewBtnRegister, viewBtnHave
            ])
        
        let container = ASInsetLayoutSpec(
            insets: .init(top: 10, left: 10, bottom: 10, right: 10),
            child: stackFields)
        
        return container
    }
}
