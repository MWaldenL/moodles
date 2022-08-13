import Foundation
import AsyncDisplayKit


class TextMuted: TextBase {
    override var label: String {
        get { self._label }
        set(val) {
            _label = val
            self.attributedText = NSAttributedString(
                string: val,
                attributes: Styles.textMuted)
        }
    }
    
    override func didLoad() {
        super.didLoad()
        self.attributedText = NSAttributedString(
            string: self.label,
            attributes: Styles.textMuted)
    }
}
