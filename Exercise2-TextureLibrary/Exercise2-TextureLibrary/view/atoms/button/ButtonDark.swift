import Foundation
import AsyncDisplayKit


class ButtonDark: ButtonFilledBase {
    override func didLoad() {
        super.didLoad()
        self.backgroundColor = Styles.Color.dark
    }
}
