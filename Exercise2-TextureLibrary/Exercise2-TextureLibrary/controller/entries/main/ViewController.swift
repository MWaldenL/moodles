import UIKit
import AsyncDisplayKit


class ViewController: ASDKNavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = [
            MainViewController(node: MainViewNode())
        ]
    }
}
