import Foundation
import AsyncDisplayKit


class DatePicker : ASDisplayNode {
    var datePickerMode: UIDatePicker.Mode = .date
    
    convenience init(mode: UIDatePicker.Mode) {
        self.init()
        self.datePickerMode = mode
    }
    
    override init() {
        super.init()
        self.setViewBlock({
            let picker = UIDatePicker()
            picker.preferredDatePickerStyle = .compact
            picker.datePickerMode = self.datePickerMode
            picker.subviews[0].subviews[0].subviews[0].alpha = 0 // transparent background for the date picker
            return picker
        })
    }
    
    override func didLoad() {
        super.didLoad()
    }
}

