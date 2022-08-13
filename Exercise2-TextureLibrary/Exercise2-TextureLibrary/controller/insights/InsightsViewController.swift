import Foundation
import AsyncDisplayKit
import RxSwift
import ReSwift


class InsightsViewController: ASDKViewController<InsightsViewNode>, StoreSubscriber {
    typealias StoreSubscriberStateType = AppState
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavbar()
        self.setEventListeners()
        
        store.dispatch(TagThunk.getTagsByUserId(store.state.authState.userId)) // TODO: lol uncomment if you're bailing out
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
        
        store.dispatch(TagThunk.getTagsByUserId(store.state.authState.userId)) // TODO: lol uncomment if you're bailing out
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setTagPillsByPeriod(
            timePeriod: store.state.insightsState.currentInsightPeriod)
        
        self.setTagPillsByMood(
            store.state.insightsState.currentMoodLevel)
    }
    
    func newState(state: StoreSubscriberStateType) {
        self.node.showInsights()
        self.node.setNeedsLayout()
        self.node.cardPills.setNeedsLayout()
    }
    
    private func setTagPillsByMood(_ moodLevel: Float) {
        store.dispatch(ActionFilterByMoodLevel(moodLevel: moodLevel))
        
        // Create the tag counts
        var tagCounts: [String: Int] = [:]
        for tag in store.state.insightsState.currentTagsByMood {
            let name = tag.tagName
            if !tag.entryIdSet.isEmpty {
                tagCounts[name] = tag.entryIdSet.count
            }
        }
        
        // Show the tag counts
        self.node.cardPills.pills = []
        for tag in tagCounts {
            self.node.cardPills.pills.append(
                TextPillCount(
                    label: tag.key,
                    count: tag.value))
        }
    }
    
    private func setTagPillsByPeriod(timePeriod: Int) {
        store.dispatch(
            ActionSetCurrentInsightPeriod(
                selectedInsightPeriod: timePeriod))
        
        switch timePeriod {
        case 0: // this week
            store.dispatch(
                ActionFilterInsightTagsByWeek(
                    week: DateService.getCurrentWeek()))
        case 1: // last week
            store.dispatch(
                ActionFilterInsightTagsByWeek(
                    week: DateService.getPreviousWeek()))
        case 2: // previous month
            store.dispatch(
                ActionFilterInsightTagsByMonth(
                    month: DateService.getCurrentMonth() - 1))
        case 3:
            store.dispatch(
                ActionFilterInsightTagsAll())
        default:
            break
        }
    }
}

//- MARK: UI
extension InsightsViewController {
    private func setNavbar() {
        // Colored navbar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Styles.Color.primary
        appearance.titleTextAttributes = Styles.textWhite
        self.navigationController?.navigationBar.standardAppearance = appearance;
        self.navigationController?.navigationBar.scrollEdgeAppearance =
            self.navigationController?.navigationBar.standardAppearance
        
        self.navigationItem.title = Constants.TITLE_INSIGHTS
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.titleTextAttributes = Styles.textBlue
    }
    
    private func setEventListeners() {
        // Selector
        let selectorTimePeriod = self.node.selectorTimePeriod.view as! UISegmentedControl
        selectorTimePeriod.rx.value
            .subscribe(
                onNext: { i in
                    self.setTagPillsByPeriod(timePeriod: i)
                    self.node.cardPills.setNeedsLayout()
                    self.node.setNeedsLayout()
                })
            .disposed(by: self.disposeBag)
        
        // Slider
        let slider = self.node.cardSlider.sliderMood.view as! UISlider
        slider.rx.value
            .subscribe(
                onNext: { moodLevel in
                    // Filter by mood level
                    self.setTagPillsByMood(moodLevel)
                    self.node.cardPills.setNeedsLayout()
                    self.node.setNeedsLayout()
                })
            .disposed(by: self.disposeBag)
    }
}
