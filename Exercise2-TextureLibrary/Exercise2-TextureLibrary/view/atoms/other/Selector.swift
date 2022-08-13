import Foundation
import AsyncDisplayKit


class Selector: ASDisplayNode {
    var tabs: [String] = []
    
    convenience init(tabs: [String]) {
        self.init()
        self.tabs = tabs
    }
    
    override init() {
        super.init()
        self.setViewBlock({
            let selector = UISegmentedControl()
            let titles = self.tabs
            for (i, title) in titles.enumerated() {
                selector.insertSegment(withTitle: title, at: i, animated: false)
            }
            
            selector.selectedSegmentIndex = 0
            selector.selectedSegmentTintColor = Styles.Color.orange
            selector.backgroundColor = .white // Styles.Color.babyBlue2
            selector.setTitleTextAttributes([ .foregroundColor: Styles.Color.orange ], for: .normal)
            selector.setTitleTextAttributes([ .foregroundColor: UIColor.white ], for: .selected)
            
            return selector
        })
    }
}
