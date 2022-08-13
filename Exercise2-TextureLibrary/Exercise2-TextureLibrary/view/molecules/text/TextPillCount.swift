import Foundation
import AsyncDisplayKit


class TextPillCount: ASDisplayNode {
    let textPill = TextPill(label: "Sample Pill")
    let textCount = TextMuted(label: "x 3")
    
    convenience init(label: String, count: Int) {
        self.init()
        textPill.label = label
        textCount.label = "x \(count)"
    }
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        textCount.style.height = .init(unit: .points, value: 20)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stackPill = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 5,
            justifyContent: .center,
            alignItems: .center,
            flexWrap: .wrap,
            alignContent: .stretch,
            children: [textPill, textCount])
        
        let container = ASInsetLayoutSpec(
            insets: .init(top: 10, left: 10, bottom: 10, right: 10),
            child: stackPill)
        
        return container
    }
}
