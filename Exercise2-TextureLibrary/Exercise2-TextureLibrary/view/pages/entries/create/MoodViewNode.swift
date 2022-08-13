import Foundation
import AsyncDisplayKit

class MoodViewNode: ASDisplayNode {
    private let labelTitle = ASTextNode()
    let btnNext = ButtonPrimary(name: Constants.LABEL_BTN_NEXT)
    
    let ivDate = ASImageNode()
    let dpDate = DatePicker()
    
    let ivTime = ASImageNode()
    let dpTime = ASDisplayNode(viewBlock: {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .time
        return picker
    })
    let sliderMood = Slider()
    
    override init() {
        super.init()
        backgroundColor = .white
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        // Date Picker
        ivDate.image = UIImage(systemName: "calendar")
        ivDate.style.height = .init(unit: .points, value: 20)
        ivDate.style.width = .init(unit: .points, value: 20)
        dpDate.style.height = .init(unit: .points, value: 40)
        dpDate.style.flexBasis = ASDimensionMake("30%")
        
        // Time Picker
        ivTime.image = UIImage(systemName: "clock")
        ivTime.style.height = .init(unit: .points, value: 20)
        ivTime.style.width = .init(unit: .points, value: 20)
        dpTime.style.height = .init(unit: .points, value: 40)
        dpTime.style.flexBasis = ASDimensionMake("30%")
        
        // Title label
        let titleMain = NSMutableAttributedString(string: Constants.HOME_TITLE, attributes: Styles.textHeader)
        labelTitle.attributedText = titleMain
        labelTitle.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        // Slider
        sliderMood.style.height = .init(unit: .points, value: 40)
        sliderMood.style.width = .init(unit: .points, value: 250)
    }
    
    func setViewValues(from entryRequest: EntryRequest) {
        (self.dpDate.view as! UIDatePicker).date = entryRequest.date
        (self.dpTime.view as! UIDatePicker).date = entryRequest.date
        (self.sliderMood.view as! UISlider).value = entryRequest.moodLevel
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stackDateTime = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .center,
            alignItems: .stretch,
            flexWrap: .wrap,
            alignContent: .center,
            lineSpacing: 10,
            children: [
                ASStackLayoutSpec(
                    direction: .horizontal,
                    spacing: 10,
                    justifyContent: .center,
                    alignItems: .stretch,
                    flexWrap: .wrap,
                    alignContent: .center,
                    lineSpacing: 10,
                    children: [ // stackDate
                        ASInsetLayoutSpec(
                            insets: .init(top: 10, left: 0, bottom: 10, right: 0),
                            child: ivDate),
                        dpDate]),
                
                ASStackLayoutSpec(
                    direction: .horizontal,
                    spacing: 10,
                    justifyContent: .center,
                    alignItems: .stretch,
                    flexWrap: .wrap,
                    alignContent: .center,
                    lineSpacing: 10,
                    children: [ // stackTime
                        ASInsetLayoutSpec(
                            insets: .init(top: 10, left: 0, bottom: 10, right: 0),
                            child: ivTime),
                        dpTime])])
        
        let stackTitle = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .center,
            alignItems: .center,
            flexWrap: .wrap,
            alignContent: .center,
            lineSpacing: 10,
            children: [self.labelTitle, self.sliderMood])
        
        let stackButtons = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .center,
            alignItems: .center,
            flexWrap: .wrap,
            alignContent: .center,
            lineSpacing: 10,
            children: [self.btnNext])
        
        let stackContainer = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .spaceBetween,
            alignItems: .stretch,
            flexWrap: .wrap,
            alignContent: .center,
            lineSpacing: 10,
            children: [stackDateTime, stackTitle, stackButtons])
        
        let container = ASInsetLayoutSpec(
            insets: .init(top: 100, left: 10, bottom: safeAreaInsets.bottom + 30, right: 10),
            child: stackContainer)
        
        return container
    }
    
    override func safeAreaInsetsDidChange() {
        self.setNeedsLayout()
    }
}
