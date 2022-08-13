import Foundation
import AsyncDisplayKit


class AccountViewNode: ASDisplayNode {
    let tvGreeting = TextHeader(label: "Hello, User!")
    let btnLogout = ButtonPrimary(name: "Logout")
    
    override init() {
        super.init()
        backgroundColor = .white
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        tvGreeting.label = "Hello, \(store.state.userState.currentUser.name)"
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stackGreetingLogout = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 50,
            justifyContent: .center,
            alignItems: .center,
            flexWrap: .wrap,
            alignContent: .center,
            lineSpacing: 10,
            children: [tvGreeting, btnLogout])
        
        let container = ASInsetLayoutSpec(
            insets: .init(top: 10, left: 10, bottom: 10, right: 10),
            child: stackGreetingLogout)
        
        return container
    }
}
