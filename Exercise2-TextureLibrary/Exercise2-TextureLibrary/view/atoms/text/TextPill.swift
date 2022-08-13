import Foundation
import AsyncDisplayKit


class TextPill: ASTextNode {
    var label: String = ""
    
    convenience init(label: String) {
        self.init()
        automaticallyManagesSubnodes = true
        self.label = label
    }
    
    override func didLoad() {
        super.didLoad()
        self.attributedText = NSAttributedString(
            string: self.label,
            attributes: Styles.textBlue
        )
        self.textContainerInset = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
        self.borderWidth = 1
        self.borderColor = Styles.Color.primary.cgColor
        self.cornerRadius = 15
    }
}
