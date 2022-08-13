import Foundation
import AsyncDisplayKit


class ButtonLinkLight: ButtonBase {
    override func didLoad() {
        super.didLoad()
        self.setTitle(self.label, with: nil, with: .white, for: .normal)
    }
    
    func setLabel(label: String) {
        self.label = label
        self.setTitle(label, with: nil, with: .white, for: .normal)
    }
}
