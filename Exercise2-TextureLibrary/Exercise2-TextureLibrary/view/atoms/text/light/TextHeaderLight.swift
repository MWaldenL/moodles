import Foundation
import AsyncDisplayKit


class TextHeaderLight : ASTextNode {
    var label = ""
    
    convenience init(label: String) {
        self.init()
        self.label = label
    }
    
    override func didLoad() {
        super.didLoad()
        self.attributedText = NSAttributedString(
            string: self.label,
            attributes: Styles.textHeaderLight)
    }
}
