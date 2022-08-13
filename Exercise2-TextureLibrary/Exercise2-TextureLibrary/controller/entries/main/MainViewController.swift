import Foundation
import AsyncDisplayKit
import ReSwift
import RxSwift
import RxCocoa
import Alamofire


class MainViewController: ASDKViewController<MainViewNode>, StoreSubscriber {
    typealias StoreSubscriberStateType = AppState
    private let disposeBag = DisposeBag()
    private let barButtonItem: UIBarButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "person"),
        style: .plain,
        target: nil,
        action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavBar()
        
        // Set bar button item
        barButtonItem.tintColor = .white
        self.navigationController?
            .navigationBar
            .topItem?.rightBarButtonItem = barButtonItem
        
        // Card list
        self.node.cardList.delegate = self
        self.node.cardList.dataSource = self
        self.node.cardList.view.separatorStyle = .none
        
        // Set event handlers
        self.setEventHandlers()
                
        // Set current user
        if store.state.userState.currentUser.id.isEmpty {
            store.dispatch(
                UserThunk.getCurrentUser())
        }
        
        // Fetch user tags
        store.dispatch(
            TagThunk.getTagsByUserId(
                store.state.authState.userId))
        
        // Set long press recognizer
        let longPressRecognizer = UILongPressGestureRecognizer(
            target: self,
            action: #selector(onLongPressed))
        self.node.cardList.view.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc func onLongPressed(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let table = self.node.cardList.view
            let loc = sender.location(in: table)
            if let indexPath = self.node.cardList.indexPathForRow(at: loc) {
                let entryId = store.state.entryState._entries[indexPath.row].id
                
                let alertDialog = UIAlertController(
                    title: "Delete entry",
                    message: "Are you sure to delete this entry?",
                    preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(
                    title: "Cancel",
                    style: .cancel,
                    handler: { action in
                        alertDialog.dismiss(animated: true)
                    })
                
                let deleteAction = UIAlertAction(
                    title: "Delete",
                    style: .destructive,
                    handler: { action in
                        store.dispatch(
                            ActionDeleteEntry(entryId: entryId))
                        
                        store.dispatch(
                            EntryThunk.deleteEntry(entryId: entryId))
                    })
                
                alertDialog.addAction(cancelAction)
                alertDialog.addAction(deleteAction)
                present(alertDialog, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }
    
    func newState(state: StoreSubscriberStateType) {
        self.node.cardList.reloadData()
        
        self.node.btnSelectWeek.setLabel(
            label: DateService.weekString(week: store.state.entryState.currentWeek))
        
        self.node.btnSelectMonth.setLabel(
            label: DateService.monthString(month: store.state.entryState.currentMonth))
        
        self.node.showEntriesList = !store.state.entryState._entries.isEmpty
        self.node.labelNumEntries.label = "\(store.state.entryState._entries.count) Entries"
        self.node.setNeedsLayout()
    }
    
    private func setNavBar() {
        let navC = self.navigationController
        let navBar = navC?.navigationBar
        
        // Colored navbar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Styles.Color.primary
        appearance.titleTextAttributes = Styles.textWhite
        navBar?.standardAppearance = appearance
        navBar?.scrollEdgeAppearance = navBar?.standardAppearance
        
        navC?.view.isUserInteractionEnabled = true
        
        navBar?.isUserInteractionEnabled = true
        navBar?.titleTextAttributes = Styles.textBlue
        navBar?.topItem?.title = Constants.TITLE_MAIN
        navBar?.topItem?.rightBarButtonItem?.isEnabled = true
    }
    
    private func setEventHandlers() {
        // Bar button item
        barButtonItem.rx.tap
            .subscribe(onNext: {
                self.navigationController?.pushViewController(
                    AccountViewController(node: AccountViewNode()),
                    animated: true)
            })
            .disposed(by: self.disposeBag)
        
        // Time period selector
        let selectorTimePeriod = (self.node.selectorTimePeriod.view as! UISegmentedControl)
        selectorTimePeriod.selectedSegmentIndex = 0
        selectorTimePeriod.rx.value
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { timePeriod in
                store.dispatch(
                    ActionSetEntryTimePeriod(
                        timePeriod: timePeriod))
                
                switch timePeriod {
                case 0: // day
                    store.dispatch(
                        EntryThunk.fetchEntriesByDay(
                            day: store.state.entryState.currentDay))
                case 1: // week
                    store.dispatch(
                        EntryThunk.fetchEntriesByWeek(
                            week: store.state.entryState.currentWeek))
                case 2: // month           
                    store.dispatch(
                        EntryThunk.fetchEntriesByMonth(
                            month: store.state.entryState.currentMonth))
                case 3:
                    store.dispatch(
                        EntryThunk.getAllEntries())

                default:
                    break
                }
                self.node.setTimePeriodView(ind: timePeriod)
            })
            .disposed(by: disposeBag)

        // Date picker
        let datePicker = self.node.dpDay.view as! UIDatePicker
        datePicker.rx.value
            .subscribe(
                onNext: { date in
                    if date != store.state.entryState.currentDay {
                        store.dispatch(
                            EntryThunk.fetchEntriesByDay(
                                day: date))
                    }
                })
            .disposed(by: self.disposeBag)
        
        // Week Button
        self.node.btnSelectWeek.rxTap
            .subscribe(onNext: {
                self.navigationController?.pushViewController(
                    WeekListViewController(node: WeekViewNode()),
                    animated: true)
            })
            .disposed(by: self.disposeBag)
        
        // Month button
        self.node.btnSelectMonth.rxTap
            .subscribe(onNext: {
                self.navigationController?.pushViewController(
                    MonthListViewController(node: MonthViewNode()),
                    animated: true)
            })
            .disposed(by: self.disposeBag)
    }
}

//- MARK: Table view Data Source methods
extension MainViewController: ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return store.state.entryState._entries.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let entry = store.state.entryState._entries[indexPath.row]
        let tags = entry.tags
        let cell = EntryCell(entry: entry, tagList: tags)
        cell.createViews(with: entry)
        cell.btnAddNote.rxTap
            .subscribe(onNext: {
                guard let cell = cell.btnAddNote.supernode as? EntryCell,
                      let ind = self.node.cardList.indexPath(for: cell)?.row
                else { return }
                
                store.dispatch(
                    ActionSetEntryId(
                        id: store.state.entryState._entries[ind].id))
                
                self.navigationController?.pushViewController(
                    AddNoteViewController(node: AddNoteViewNode()),
                    animated: true)
            })
            .disposed(by: self.disposeBag)
        return cell
    }
}

//- MARK: Table view Delegate methods
extension MainViewController: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        store.dispatch(
            ActionSetEntryId(
                id: store.state.entryState._entries[indexPath.row].id))
        
        self.navigationController?.pushViewController(
            MoodViewController(node: MoodViewNode()),
            animated: true)
    }
}
