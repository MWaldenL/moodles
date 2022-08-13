import Foundation
import AsyncDisplayKit
import RxSwift


class ButtonPill: ButtonBase {
    var color = UIColor.black
    override var label: String {
        get { _label }
        set(val) {
            _label = val
            self.setTitle(
                val,
                with: Styles.Fonts.helveticaBold16,
                with: self.color,
                for: .normal)
        }
    }
    
    convenience init(name: String, color: UIColor) {
        self.init(name: name)
        self.color = color
    }
    
    override func didLoad() {
        super.didLoad()
        
        self.setTitle(
            self.label,
            with: Styles.Fonts.helveticaBold16,
            with: self.color,
            for: .normal)
        self.contentEdgeInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
        self.borderWidth = 1
        self.borderColor = self.color.cgColor
        self.cornerRadius = 15
    }
    
    func setColor(color: UIColor) {
        self.setTitle(
            self.label,
            with: Styles.Fonts.helveticaBold16,
            with: color,
            for: .normal)
        self.borderColor = color.cgColor
    }
}
