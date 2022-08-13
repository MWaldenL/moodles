import Foundation
import AsyncDisplayKit
import RxSwift


class ButtonFilledBase: ButtonBase {
    override func didLoad() {
        super.didLoad()
        self.setTitle(self.label, with: nil, with: .white, for: .normal)
        self.style.height = .init(unit: .points, value: 40)
        self.style.width = .init(unit: .points, value: 200)
        self.cornerRadius = 10
    }
}

