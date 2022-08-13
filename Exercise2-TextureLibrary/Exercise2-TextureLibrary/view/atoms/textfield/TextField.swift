import Foundation
import AsyncDisplayKit


struct TextField {
    static func create() -> ASEditableTextNode {
        let textField = ASEditableTextNode()
        
        textField.attributedPlaceholderText = NSAttributedString(
            string: Constants.PH_TAG,
            attributes: Styles.textPlaceholder)
        textField.textView.font = Styles.Fonts.helvetica16
        textField.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textField.borderColor = Styles.Color.grey50.cgColor
        textField.borderWidth = 0.5
        textField.cornerRadius = 10
        textField.maximumLinesToDisplay = 1
        textField.enablesReturnKeyAutomatically = false
        
        return textField
    }
}
