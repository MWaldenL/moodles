import Foundation
import AsyncDisplayKit


class WeekCell: ASCellNode {
    var weekName = ""
    let tvName = ASTextNode()
    
    override init() {
        super.init()
        backgroundColor = .white
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        tvName.attributedText = NSAttributedString(
            string: self.weekName,
            attributes: Styles.textBody)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(
            insets: .init(top: 10, left: 10, bottom: 10, right: 10),
            child: tvName)
    }
}
