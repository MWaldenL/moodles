import Foundation
import AsyncDisplayKit


class FormInputField: ASDisplayNode {
    var _tvLabel = TextLabelLight()
    private var _label = ""
    var label: String {
        get { return self._label }
        set(value) {
            _tvLabel.label = value
        }
    }
    
    var placeholder = ""
    var inputField = TextFieldLight()
    
    var fieldText: String {
        get { (self.inputField.textField.view as! UITextField).text ?? "" }
    }
    
    convenience init(label: String, placeholder: String = "", isPassword: Bool = false) {
        self.init()
        self._label = label
        self.placeholder = placeholder
        self.inputField = TextFieldLight(placeholder: placeholder, isPassword: isPassword)
    }
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        _tvLabel.label = self._label
        inputField.placeholder = self.placeholder
        inputField.style.height = Styles.Dimens._40
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stackInput = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .start,
            alignItems: .stretch,
            flexWrap: .wrap,
            alignContent: .stretch,
            lineSpacing: 10,
            children: [_tvLabel, inputField])
        
        let container = ASInsetLayoutSpec(
            insets: .init(top: 10, left: 10, bottom: 10, right: 10),
            child: stackInput
        )
        
        return container
    }
}
