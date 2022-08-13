import Foundation
import AsyncDisplayKit


class TextLabelLight: TextLabel {
    override func didLoad() {
        super.didLoad()
        self.attributedText = NSAttributedString(
            string: self.label,
            attributes: Styles.textLabelWhite)
    }
}
