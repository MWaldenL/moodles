import Foundation
import AsyncDisplayKit


class SliderBlue: ASDisplayNode {
    override init() {
        super.init()
        self.setViewBlock({ [weak self] in
            let slider = UISlider()
            slider.minimumValue = 1
            slider.maximumValue = 5
            slider.value = 3
            slider.minimumTrackTintColor = Styles.Color.babyBlue2
            slider.setThumbImage(UIImage(systemName: "circle.fill"), for: .normal)
            slider.thumbTintColor = Styles.Color.babyBlue2
            slider.isContinuous = false
            slider.addTarget(self,
                             action: #selector(self?.onValueChanged(_:)),
                             for: .valueChanged)
            return slider
        })
    }
    
    @objc func onValueChanged(_ sender: UISlider) {
        sender.setValue(Float(lroundf(sender.value)), animated: false)
    }
}

