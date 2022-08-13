import Foundation
import AsyncDisplayKit


class TextBase: ASTextNode {
    internal var _label = ""
    var label: String {
        get { _label }
        set(val) {
            self._label = val
        }
    }
    
    convenience init(label: String) {
        self.init()
        self._label = label
    }
}
