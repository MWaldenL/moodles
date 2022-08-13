import Foundation
import UIKit
import AsyncDisplayKit


class NavInsightsViewController: ASDKNavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = [
            InsightsViewController(node: InsightsViewNode())
        ]
    }
}
