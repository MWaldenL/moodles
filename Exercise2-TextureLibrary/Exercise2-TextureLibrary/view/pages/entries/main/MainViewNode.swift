import Foundation
import AsyncDisplayKit


class MainViewNode: ASDisplayNode {
    let imgCal = ASImageNode()
    let imgNoEntries = ASImageNode()
    
    let labelNumEntries = TextMuted(label: "")
    let labelNoEntries = TextMuted(label: "No records found")
    let labelAll = ButtonLink(name: "All Entries")
    
    // Time Period Selectors
    let dpDay = DatePicker()
    let btnSelectWeek = ButtonLink(name: "Week")
    let btnSelectMonth = ButtonLink(name: "Month")
    
    let selectorTimePeriod = Selector(tabs: ["Day", "Week", "Month", "All"])
    let cardList = ASTableNode()
    
    var pickerViewChildren: [ASLayoutElement] = []
    var showEntriesList = true
    
    override init() {
        super.init()
        backgroundColor = .white
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        imgCal.image = UIImage(systemName: "calendar")
        imgCal.style.height = .init(unit: .points, value: 20)
        imgCal.style.width = .init(unit: .points, value: 20)
        
        imgNoEntries.image = UIImage(
            systemName: "bubble.left",
            withConfiguration: UIImage.SymbolConfiguration(textStyle: .largeTitle))
        
        dpDay.style.height = .init(unit: .points, value: 40)
        dpDay.style.width = .init(unit: .points, value: 80)
        
        labelNumEntries.style.height = .init(unit: .points, value: 40)
        labelAll.style.height = .init(unit: .points, value: 40)
        labelNoEntries.style.height = .init(unit: .points, value: 40)
        
        btnSelectWeek.style.height = .init(unit: .points, value: 40)
        btnSelectMonth.style.height = .init(unit: .points, value: 40)
        
        selectorTimePeriod.style.height = .init(unit: .points, value: 40)
        
        cardList.style.height = .init(unit: .fraction, value: 0.7)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let viewSelector = ASInsetLayoutSpec(
            insets: .init(top: 10, left: 10, bottom: 10, right: 10),
            child: selectorTimePeriod)
    
        let stackDay = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 10,
            justifyContent: .spaceBetween,
            alignItems: .center,
            flexWrap: .wrap,
            alignContent: .center,
            lineSpacing: 10,
            children: [imgCal] + self.pickerViewChildren)
        
        let viewDay = ASCenterLayoutSpec(
            centeringOptions: .XY,
            sizingOptions: [],
            child: stackDay)
        
        let stackLabelCount = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 10,
            justifyContent: .start,
            alignItems: .center,
            flexWrap: .wrap,
            alignContent: .center,
            lineSpacing: 10,
            children: [labelNumEntries])
        
        let viewLabelCount = ASInsetLayoutSpec(
            insets: .init(top: 10, left: 10, bottom: 0, right: 10),
            child: stackLabelCount)
        
        let viewEntries = ASInsetLayoutSpec(
            insets: .init(top: 0, left: 10, bottom: 10, right: 10),
            child: cardList)
        
        let stackNoEntries = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .center,
            alignItems: .center,
            flexWrap: .wrap,
            alignContent: .center,
            lineSpacing: 10,
            children: [imgNoEntries, labelNoEntries])
            stackNoEntries.style.height = .init(unit: .fraction, value: 0.7)
        
        let stackParent = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .start,
            alignItems: .stretch,
            flexWrap: .wrap,
            alignContent: .center,
            children: [viewSelector, viewDay, viewLabelCount] +
                (self.showEntriesList ? [viewEntries] : [stackNoEntries]))
        
        let container = ASInsetLayoutSpec(
            insets: .init(top: safeAreaInsets.top + 10, left: 10, bottom: safeAreaInsets.bottom, right: 10),
            child: stackParent)
        
        return container
    }
    
    override func safeAreaInsetsDidChange() {
        self.setNeedsLayout()
    }
    
    func setTimePeriodView(ind: Int) {
        let timePeriodViews = [dpDay, btnSelectWeek, btnSelectMonth, labelAll]
        self.pickerViewChildren = [timePeriodViews[ind]]
        self.setNeedsLayout()
    }
}
