import Foundation
import AsyncDisplayKit


class AddNoteViewNode: ASDisplayNode {
    let tfNote = ASEditableTextNode()
    var note = ""
    
    override init() {
        super.init()
        backgroundColor = .white
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()

        // Note text field
        tfNote.attributedPlaceholderText = NSAttributedString(
            string: Constants.PH_ADD_NOTE,
            attributes: Styles.textBody)
        tfNote.textView.font = Styles.Fonts.helvetica16
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let container = ASInsetLayoutSpec(
            insets: .init(top: 100, left: 10, bottom: 10, right: 10),
            child: tfNote)
        return container
    }
    
    func setNote(withNote note: String) {
        tfNote.attributedText = NSAttributedString(
            string: note,
            attributes: Styles.textBody)
    }
}
