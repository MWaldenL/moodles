import Foundation
import AsyncDisplayKit


class TextHeader : TextBase {
    override func didLoad() {
        super.didLoad()
        self.attributedText = NSAttributedString(
            string: self.label,
            attributes: Styles.textHeader)
    }
}
