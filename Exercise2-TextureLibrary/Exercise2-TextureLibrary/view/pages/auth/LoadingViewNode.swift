import Foundation
import AsyncDisplayKit


class LoadingViewNode: ASDisplayNode {
    let imgLoading = ASImageNode()
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        backgroundColor = .white
    }
    
    override func didLoad() {
        super.didLoad()
        imgLoading.style.width = Styles.Dimens._80
        imgLoading.style.height = Styles.Dimens._80
        imgLoading.image = UIImage(systemName: "ellipsis")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let viewLoading = ASInsetLayoutSpec(
            insets: .init(top: 10, left: 10, bottom: 10, right: 10),
            child: imgLoading)
        
        let container = ASInsetLayoutSpec(
            insets: .init(top: 10, left: 10, bottom: 10, right: 10),
            child: viewLoading)
        
        return container
    }
}
