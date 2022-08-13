import Foundation
import AsyncDisplayKit
import RxSwift

class MoodViewController: BaseViewController {
    var moodViewNode: MoodViewNode!
    
    override init(node: ASDisplayNode) {
        super.init(node: MoodViewNode())
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
        self.navTitle = store.state.entryState.isEditingEntry ?
            Constants.TITLE_EDIT_ENTRY :
            Constants.TITLE_NEW_ENTRY
        
        self.moodViewNode = self.node as? MoodViewNode
        moodViewNode.setViewValues(from: store.state.entryState.newEntryRequest)
        
        // Event listeners
        self.setEventListeners()
    }
    
    private func setEventListeners() {
        moodViewNode.btnNext.rxTap
            .subscribe(
                onNext: {
                    self.navigationController?.pushViewController(
                        TagsViewController(node: TagsViewNode()), animated: true)
                })
            .disposed(by: disposeBag)
    
        let sliderMood = moodViewNode.sliderMood.view as! UISlider
        sliderMood.rx.value
            .subscribe(
                onNext: { val in
                    store.dispatch(
                        ActionSetNewEntryMood(
                            mood: (self.moodViewNode.sliderMood.view as! UISlider).value))
                })
            .disposed(by: disposeBag)
        
        let dpDate = moodViewNode.dpDate.view as! UIDatePicker
        dpDate.rx.value
            .subscribe(
                onNext: { date in
                    store.dispatch(
                        ActionSetNewEntryDate(
                            date: date))
                })
            .disposed(by: disposeBag)
        
        let dpTime = moodViewNode.dpTime.view as! UIDatePicker
        dpTime.rx.value
            .subscribe(
                onNext: { date in
                    store.dispatch(
                        ActionSetNewEntryDate(
                            date: date))
                })
            .disposed(by: disposeBag)
    }
}
