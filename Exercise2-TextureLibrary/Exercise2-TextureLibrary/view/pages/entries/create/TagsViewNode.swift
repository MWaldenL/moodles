import Foundation
import AsyncDisplayKit
import UIKit

protocol TagDelegate: AnyObject {
    func onTagAdded(fromPill pill: ButtonPill)
}

class TagsViewNode: ASDisplayNode {
    let labelTitle = ASTextNode()
    let tfTag = TextFieldButton(label: "Add Tag")
    let ivAddNote = ASImageNode()
    let btnAddNote = ButtonLink(name: Constants.LABEL_BTN_ADD_NOTE)
    let btnDone = ButtonPrimary(name: Constants.LABEL_BTN_DONE)
    var selectedPills: [ButtonPill] = []
    var pills: [ButtonPill] = []
    
    weak var delegate: TagDelegate?
    
    override init() {
        super.init()
        backgroundColor = .white
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        // Recent Label
        labelTitle.attributedText = NSAttributedString(
            string: Constants.LABEL_RECENT,
            attributes: Styles.textTitle)

        // Set the pills
        self.setPills()
        
        ivAddNote.image = UIImage(systemName: "doc.text")
        ivAddNote.style.height = .init(unit: .points, value: 20)
        ivAddNote.style.width = .init(unit: .points, value: 20)
    }
    
    func setPills() {
        // Unselected pills
        let unselectedPills = store.state.tagState.userTagRequests
            .subtracting(store.state.entryState.newEntryRequest.tags)
        
        for tag in unselectedPills {
            pills.append(ButtonPill(name: tag.tagName))
        }
        pills.append(ButtonPill(name: "..."))
        
        // Selected pills
        for tag in store.state.entryState.newEntryRequest.tags {
            selectedPills.append(ButtonPill(name: tag.tagName,color: Styles.Color.orange))
        }
    }

    func addToSelectedTags(with tagName: String) {
        let pill = ButtonPill(name: tagName)
        let selectedPill = ButtonPill(name: tagName, color: Styles.Color.orange)
        
        pill.style.height = .init(unit: .points, value: 30)
        selectedPill.style.height = .init(unit: .points, value: 30)
        
        self.selectedPills.insert(selectedPill, at: 0)
        delegate?.onTagAdded(fromPill: selectedPill)
    }
    
    func removeFromTagCloud(with tagName: String) {
        self.pills.removeAll(where: { $0.label == tagName })
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stackSelectedPills = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 10,
            justifyContent: .center,
            alignItems: .stretch,
            flexWrap: .wrap,
            alignContent: .stretch,
            lineSpacing: 10,
            children: selectedPills)
        
        let stackSearchSelected = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .center,
            alignItems: .stretch,
            flexWrap: .wrap,
            alignContent: .stretch,
            lineSpacing: 10,
            children: [tfTag, stackSelectedPills])
        
        // Recent
        let stackRecentTitle = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 10,
            justifyContent: .center,
            alignItems: .center,
            flexWrap: .wrap,
            alignContent: .center,
            lineSpacing: 10,
            children: [labelTitle])
        
        let stackRecentPills = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 10,
            justifyContent: .center,
            alignItems: .stretch,
            flexWrap: .wrap,
            alignContent: .stretch,
            lineSpacing: 10,
            children: pills)
        
        let stackRecent = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 20,
            justifyContent: .spaceBetween,
            alignItems: .stretch,
            flexWrap: .wrap,
            alignContent: .stretch,
            children: [stackRecentTitle, stackRecentPills])
        
        // Add Note
        let stackAddNote = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 8,
            justifyContent: .center,
            alignItems: .stretch,
            flexWrap: .wrap,
            alignContent: .stretch,
            children: [ivAddNote, btnAddNote])
        
        // Buttons
        let stackButtons = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .center,
            alignItems: .center,
            flexWrap: .wrap,
            alignContent: .center,
            lineSpacing: 10,
            children: [self.btnDone])
        
        let stackParent = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 20,
            justifyContent: .spaceBetween,
            alignItems: .stretch,
            flexWrap: .wrap,
            alignContent: .stretch,
            children: [stackSearchSelected, stackRecent, stackAddNote, stackButtons])
        
        let container = ASInsetLayoutSpec(
            insets: .init(top: 100, left: 10, bottom: safeAreaInsets.bottom + 30, right: 10),
            child: stackParent)
        
        return container
    }
    
    override func safeAreaInsetsDidChange() {
        self.setNeedsLayout()
    }
}
