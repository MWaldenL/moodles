import Foundation
import AsyncDisplayKit
import RxSwift


class TextFieldButton: ASDisplayNode {
    var label = ""
    let textField = ASEditableTextNode()
    let button = ButtonLink(name: "")
    var tfChildren: [ASLayoutElement] = []
    var showButton: Bool {
        get { return false }
        set(val) {
            self.tfChildren = [textField] + (val ? [button] : [])
            self.setNeedsLayout()
        }
    }
    
    var text: String {
        get {
            return self.textField.textView.text
        }
    }
    
    convenience init(label: String) {
        self.init()
        
        backgroundColor = .white
        automaticallyManagesSubnodes = true
        
        self.label = label
        self.button.setLabel(label: label)
    }
    
    override func didLoad() {
        super.didLoad()
        
        self.borderColor = Styles.Color.grey50.cgColor
        self.borderWidth = 0.5
        self.cornerRadius = 10
        
        // Text Field
        textField.attributedPlaceholderText = NSAttributedString(
            string: Constants.PH_TAG,
            attributes: Styles.textPlaceholder)
        textField.textView.font = Styles.Fonts.helvetica16
        textField.textContainerInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        
        textField.maximumLinesToDisplay = 1
        textField.enablesReturnKeyAutomatically = false
        textField.style.height = .init(unit: .points, value: 30)
        textField.style.flexGrow = 2
        
        // Button
        button.style.height = .init(unit: .points, value: 30)
        
        self.tfChildren = [textField]
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stackTextField = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 10,
            justifyContent: .spaceBetween,
            alignItems: .stretch,
            flexWrap: .wrap,
            alignContent: .stretch,
            lineSpacing: 10,
            children: self.tfChildren)
        
        let container = ASInsetLayoutSpec(
            insets: .init(top: 5, left: 10, bottom: 5, right: 10),
            child: stackTextField)
        
        return container
    }
}
