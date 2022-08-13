import Foundation
import AsyncDisplayKit


class MonthViewNode: ASDisplayNode {
    let monthList = ASTableNode()
    
    override init() {
        super.init()
        backgroundColor = .white
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let container = ASInsetLayoutSpec(
            insets: .init(top: 100, left: 10, bottom: 110, right: 10),
            child: monthList)
        return container
    }
}
