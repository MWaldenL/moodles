import Foundation
import AsyncDisplayKit


class InsightsViewNode: ASDisplayNode {
    let selectorTimePeriod = Selector(tabs: ["This Week", "Last Week", "Last Month", "Overall"])
    let spinnerLoading = ASDisplayNode(viewBlock: {
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        spinner.backgroundColor = UIColor(white: 1, alpha: 0.7)
        spinner.startAnimating()
        return spinner
    })
    let cardSlider = CardSlider()
    let cardPills = CardPills()
    let scroll = ASScrollNode()
    
    var insightsStack: [ASLayoutSpec] = []
    var shouldShow = false
    
    override init() {
        super.init()
        backgroundColor = .white
        automaticallyManagesSubnodes = true
        scroll.automaticallyManagesSubnodes = true
        scroll.automaticallyManagesContentSize = true
//        scroll.layoutSpecBlock = { [self] node, constrainedSize in
//            let viewSelector = ASInsetLayoutSpec(
//                insets: .init(top: 10, left: 10, bottom: 10, right: 10),
//                child: selectorTimePeriod)
//
//            let stackSelectorSlider = ASStackLayoutSpec(
//                direction: .vertical,
//                spacing: 20,
//                justifyContent: .center,
//                alignItems: .stretch,
//                flexWrap: .wrap,
//                alignContent: .stretch,
//                children: [viewSelector, cardSlider])
//
//            let viewPills = ASCenterLayoutSpec(
//                centeringOptions: .XY,
//                sizingOptions: [],
//                child: cardPills)
//
//            let viewSpinner = ASCenterLayoutSpec(
//                centeringOptions: .XY,
//                sizingOptions: [],
//                child: spinnerLoading)
//
//            self.insightsStack = [stackSelectorSlider, viewSpinner]
//            let stackParent = ASStackLayoutSpec(
//                direction: .vertical,
//                spacing: 20,
//                justifyContent: .start,
//                alignItems: .stretch,
//                flexWrap: .wrap,
//                alignContent: .stretch,
//                children: self.insightsStack) // viewPills])
//
//            let container = ASInsetLayoutSpec(
//                insets: .init(top: 10, left: 0, bottom: safeAreaInsets.bottom, right: 0),
//                child: stackParent)
//
//            return container
//        }
    }
    
    override func didLoad() {
        super.didLoad()
        selectorTimePeriod.style.height = .init(unit: .points, value: 40)
        spinnerLoading.style.height = Styles.Dimens._60
    }
    
    func showInsights() {
        self.shouldShow = true
        self.setNeedsLayout()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let viewSelector = ASInsetLayoutSpec(
            insets: .init(top: 10, left: 10, bottom: 10, right: 10),
            child: selectorTimePeriod)
        
        let stackSelectorSlider = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 20,
            justifyContent: .center,
            alignItems: .stretch,
            flexWrap: .wrap,
            alignContent: .stretch,
            children: [viewSelector, cardSlider])
        
        let viewPills = ASCenterLayoutSpec(
            centeringOptions: .XY,
            sizingOptions: [],
            child: cardPills)
        
        let viewSpinner = ASCenterLayoutSpec(
            centeringOptions: .XY,
            sizingOptions: [],
            child: spinnerLoading)
        
        self.insightsStack = [stackSelectorSlider, viewSpinner]
        if self.shouldShow {
            self.insightsStack = [stackSelectorSlider, viewPills]
        }
        let stackParent = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 20,
            justifyContent: .start,
            alignItems: .stretch,
            flexWrap: .wrap,
            alignContent: .stretch,
            children: self.insightsStack) // viewPills])
        
        let container = ASInsetLayoutSpec(
            insets: .init(top: safeAreaInsets.top, left: 0, bottom: safeAreaInsets.bottom, right: 0),
            child: stackParent)
        
        return container
//        return ASInsetLayoutSpec(
//            insets: .init(top: safeAreaInsets.top + 10, left: 0, bottom: safeAreaInsets.bottom, right: 0),
//            child: scroll)
    }
    
    override func safeAreaInsetsDidChange() {
        self.setNeedsLayout()
    }
}
