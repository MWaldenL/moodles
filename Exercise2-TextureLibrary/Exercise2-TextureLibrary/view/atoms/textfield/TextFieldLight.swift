import Foundation
import AsyncDisplayKit
import UIKit


class TextFieldLight: ASDisplayNode {
    let textField = ASDisplayNode(viewBlock: {
        let field = UITextField()
        field.backgroundColor = .white
        field.borderStyle = .roundedRect
        return field
    })
    private var _placeholder = ""
    var placeholder: String {
        get { _placeholder }
        set(value) {
            _placeholder = value
            (textField.view as! UITextField).attributedPlaceholder = NSAttributedString(
                string: value,
                attributes: Styles.textPlaceholder)
        }
    }
    
    convenience init(placeholder: String, isPassword: Bool = false) {
        self.init()
        self._placeholder = placeholder
        (textField.view as! UITextField).autocapitalizationType = .none
        (textField.view as! UITextField).isSecureTextEntry = isPassword
    }
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let container = ASInsetLayoutSpec(
            insets: .zero,
            child: textField)
        return container
    }
}
