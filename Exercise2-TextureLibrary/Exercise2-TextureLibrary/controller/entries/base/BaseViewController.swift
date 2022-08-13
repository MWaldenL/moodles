import Foundation
import UIKit
import AsyncDisplayKit
import RxSwift


class BaseViewController: ASDKViewController<ASDisplayNode> {
    let disposeBag = DisposeBag()
    
    private var _navTitle = ""
    var navTitle: String {
        get { _navTitle }
        set(title) {
            _navTitle = title
            self.navigationItem.title = _navTitle
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = Styles.Color.primary
            appearance.titleTextAttributes = Styles.textWhite
            self.navigationController?.navigationBar.standardAppearance = appearance;
            self.navigationController?.navigationBar.scrollEdgeAppearance =
                self.navigationController?.navigationBar.standardAppearance
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = .white

        let barButton =
            UIBarButtonItem(
                barButtonSystemItem: .cancel,
                target: self,
                action: nil)
        
        barButton.tintColor = UIColor.white
        barButton.rx.tap
            .subscribe(onNext: {
                store.dispatch(ActionResetState())
                self.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: self.disposeBag)
        
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = barButton
    }
}
