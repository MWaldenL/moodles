import Foundation
import AsyncDisplayKit


class TextFieldLight2: ASDisplayNode {
    let textField = ASEditableTextNode()
    private var _placeholder = ""
    var placeholder: String {
        get { _placeholder }
        set(value) {
            _placeholder = value
            textField.attributedPlaceholderText = NSAttributedString(
                string: value,
                attributes: Styles.textPlaceholder)
        }
    }
    
    convenience init(placeholder: String) {
        self.init()
        self._placeholder = placeholder
    }
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        self.backgroundColor = Styles.Color.lightGrey
        self.borderColor = UIColor.white.cgColor
        self.borderWidth = 0.5
        self.cornerRadius = 10
        
        textField.attributedPlaceholderText = NSAttributedString(
            string: self._placeholder,
            attributes: Styles.textPlaceholder)
        textField.textView.font = Styles.Fonts.helvetica16
        textField.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textField.maximumLinesToDisplay = 1
        textField.enablesReturnKeyAutomatically = false
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let container = ASInsetLayoutSpec(
            insets: .zero,
            child: textField)
        return container
    }
}
