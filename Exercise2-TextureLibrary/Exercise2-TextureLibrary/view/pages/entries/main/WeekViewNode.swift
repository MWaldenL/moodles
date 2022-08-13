import Foundation
import AsyncDisplayKit


class WeekViewNode: ASDisplayNode {
    let weekList = ASTableNode()
    
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
            child: weekList)
        return container
    }
}
