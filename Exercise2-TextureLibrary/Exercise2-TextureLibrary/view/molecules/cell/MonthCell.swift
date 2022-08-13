import Foundation
import AsyncDisplayKit


class MonthCell: ASCellNode {
    var monthName = ""
    let tvName = ASTextNode()
    
    override init() {
        super.init()
        backgroundColor = .white
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        tvName.attributedText = NSAttributedString(
            string: self.monthName,
            attributes: Styles.textBody)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(
            insets: .init(top: 10, left: 10, bottom: 10, right: 10),
            child: tvName)
    }
}
