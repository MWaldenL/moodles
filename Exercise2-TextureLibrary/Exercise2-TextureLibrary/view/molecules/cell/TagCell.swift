import Foundation
import AsyncDisplayKit


class TagCell: ASCellNode {
    let tvName = TextPill()
    var label = ""
    
    convenience init(label: String) {
        self.init()
        self.label = label
    }
    
    override init() {
        super.init()
        backgroundColor = .white
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        tvName.label = self.label
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stackName = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 10,
            justifyContent: .center,
            alignItems: .center,
            flexWrap: .wrap,
            alignContent: .center,
            lineSpacing: 10,
            children: [tvName])
        
        return ASInsetLayoutSpec(
            insets: .init(top: 10, left: 10, bottom: 10, right: 10),
            child: stackName)
    }
}
