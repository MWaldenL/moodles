import Foundation
import AsyncDisplayKit


class CardSlider: ASDisplayNode {
    let sliderMood = Slider()
    let tvFeeling = TextHeader(label: "When I was feeling")
    let tvLow = TextLabel(label: "Low")
    let tvHigh = TextLabel(label: "High")
    let tvMoveToggle = TextLabel(label: "Move slider to see insights")

    override init() {
        super.init()
        backgroundColor = Styles.Color.babyBlue5
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        sliderMood.style.height = .init(unit: .points, value: 40)
        sliderMood.style.width = .init(unit: .fraction, value: 0.8)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stackSlider = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 30,
            justifyContent: .center,
            alignItems: .center,
            flexWrap: .wrap,
            alignContent: .center,
            children: [tvFeeling, sliderMood])
        
        let stackLowHigh = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 100,
            justifyContent: .spaceBetween,
            alignItems: .stretch,
            flexWrap: .wrap,
            alignContent: .stretch,
            children: [tvLow, tvHigh])
        stackLowHigh.style.width = .init(unit: .fraction, value: 1)
        
        let viewMoveToggle = ASInsetLayoutSpec(
            insets: .init(top: 10, left: 10, bottom: 10, right: 10),
            child: tvMoveToggle)
        
        let stackSliderWithLabel = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 20,
            justifyContent: .center,
            alignItems: .center,
            flexWrap: .wrap,
            alignContent: .center,
            children: [stackSlider, stackLowHigh, viewMoveToggle])
        
        let container = ASInsetLayoutSpec(
            insets: .init(top: 50, left: 50, bottom: 50, right: 50),
            child: stackSliderWithLabel)
        
        return container
    }
}
