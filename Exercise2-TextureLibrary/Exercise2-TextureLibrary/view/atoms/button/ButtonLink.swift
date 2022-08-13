import Foundation
import AsyncDisplayKit


class ButtonLink: ButtonBase {
    override func didLoad() {
        super.didLoad()
        self.setTitle(self.label, with: nil, with: Styles.Color.primary, for: .normal)
    }
    
    func setLabel(label: String) {
        self.label = label
        self.setTitle(self.label, with: nil, with: Styles.Color.primary, for: .normal)
    }
}
