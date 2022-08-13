import Foundation
import AsyncDisplayKit
import RxSwift


class ButtonBase: ASButtonNode {
    fileprivate var emitTap = PublishSubject<Void>()
    var _label = ""
    var label: String {
        get { _label }
        set(val) {
            _label = val
        }
    }
    
    public var rxTap: Observable<Void> {
        return emitTap.asObservable()
    }
    
    convenience init(name: String) {
        self.init()
        self._label = name
    }
    
    override func didLoad() {
        super.didLoad()
        self.addTarget(self, action: #selector(onTapped), forControlEvents: .touchUpInside)
    }
    
    @objc func onTapped() {
        print("tapped")
        emitTap.onNext(())
    }
}

