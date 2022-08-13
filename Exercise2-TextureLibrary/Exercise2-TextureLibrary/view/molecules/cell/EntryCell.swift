import Foundation
import AsyncDisplayKit


class EntryCell: ASCellNode {
    let card = ASDisplayNode()
    let tvTime = ASTextNode()
    let sliderMood = SliderBlue()
    let ivAddNote = ASImageNode()
    let btnAddNote = ButtonLink(name: Constants.LABEL_BTN_ADDED_NOTE)
    var pills = [TextPill]()
    var entry = _Entry()

    init(entry: _Entry, tagList: Set<TagEntry>) {
        // Pills
        for tag in tagList {
            pills.append(TextPill(label: tag.tagName))
        }

        super.init()
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        backgroundColor = .white
        card.borderColor = Styles.Color.babyBlue4.cgColor
        card.borderWidth = 2
        card.cornerRadius = 10
        card.backgroundColor = Styles.Color.babyBlue5
        sliderMood.isUserInteractionEnabled = false
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stackTimeMood = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 10,
            justifyContent: .start,
            alignItems: .center,
            flexWrap: .wrap,
            alignContent: .center,
            lineSpacing: 10,
            children: [tvTime, sliderMood])
        
        let stackPills = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 10,
            justifyContent: .start,
            alignItems: .center,
            flexWrap: .wrap,
            alignContent: .center,
            lineSpacing: 10,
            children: self.pills)
        
        let stackAddNote = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 10,
            justifyContent: .start,
            alignItems: .stretch,
            flexWrap: .wrap,
            alignContent: .stretch,
            lineSpacing: 10,
            children: [ivAddNote, btnAddNote])
        
        let stackEntry = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 20,
            justifyContent: .center,
            alignItems: .stretch,
            flexWrap: .wrap,
            alignContent: .center,
            lineSpacing: 20,
            children: [stackTimeMood, stackPills, stackAddNote])
        
        let cardContainer = ASInsetLayoutSpec(
            insets: .init(top: 16, left: 16, bottom: 16, right: 16),
            child: stackEntry)
        
        let container = ASBackgroundLayoutSpec(
            child: cardContainer,
            background: card
        )
        
        return ASInsetLayoutSpec(
            insets: .init(top: 8, left: 8, bottom: 8, right: 8),
            child: container)
    }
    
    func createViews(with entry: _Entry) {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"// "HH:mm"
        let time = formatter.string(from: entry.dateUpdated).lowercased()
        
        // Time text field
        tvTime.attributedText = NSAttributedString(string: time, attributes: Styles.textBlue)
        
        // Mood Slider
        sliderMood.style.height = .init(unit: .points, value: 40)
        sliderMood.style.width = .init(unit: .points, value: 200)
        (sliderMood.view as! UISlider).value = Float(entry.moodLevel)
        
        // Add note button
        btnAddNote.setTitle(
            Constants.LABEL_BTN_ADDED_NOTE,
            with: nil, with: Styles.Color.primary, for: .normal)
        
        ivAddNote.image = UIImage(systemName: "square.and.pencil")
        ivAddNote.style.height = .init(unit: .points, value: 20)
        ivAddNote.style.width = .init(unit: .points, value: 20)
    }
}
