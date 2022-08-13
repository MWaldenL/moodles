import Foundation
import AsyncDisplayKit


class CardPills: ASDisplayNode {
    let tvInsights = TextHeader(label: "Often with")
    var pills: [TextPillCount] = []
    
    override init() {
        super.init()
        backgroundColor = .white
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let viewInsights = ASInsetLayoutSpec(
            insets: .init(top: 10, left: 10, bottom: 10, right: 10),
            child: tvInsights)
        
        let stackPillsGroup = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 20,
            justifyContent: .center,
            alignItems: .stretch,
            flexWrap: .wrap,
            alignContent: .stretch,
            children: self.pills)
        
        let stackPills = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .center,
            alignItems: .center,
            flexWrap: .wrap,
            alignContent: .stretch,
            children: [viewInsights, stackPillsGroup])
        stackPills.style.flexGrow = 2
        
        return stackPills
    }
}
