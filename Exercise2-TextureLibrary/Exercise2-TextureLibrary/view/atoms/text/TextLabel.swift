import Foundation
import AsyncDisplayKit


class TextLabel: TextBase {
    override func didLoad() {
        super.didLoad()
        self.attributedText = NSAttributedString(
            string: self.label,
            attributes: Styles.textLabel)
    }
}
