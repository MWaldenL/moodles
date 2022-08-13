import Foundation
import AsyncDisplayKit
import RxSwift
import ReSwift


class AddNoteViewController: ASDKViewController<AddNoteViewNode>, StoreSubscriber {
    typealias StoreSubscriberStateType = AppState
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = Constants.TITLE_ADD_NOTE
        self.navigationController?.navigationBar.tintColor = .white
        
        let barButton =
            UIBarButtonItem(
                barButtonSystemItem: .done,
                target: self,
                action: nil)
        
        barButton.tintColor = .white
        
        // Set the currently stored note
        let tfNote = self.node.tfNote.textView
        tfNote.text = store.state.entryState.newEntryRequest.note
        tfNote.rx.text
            .subscribe(onNext: { note in
                guard let note = note else { return }
                store.dispatch(
                    ActionAddNote(
                        note: note))
            })
            .disposed(by: self.disposeBag)
        
        barButton.rx.tap
            .subscribe(
                onNext: {
                    guard let note = self.node.tfNote.textView.text else { return }
                    store.dispatch(
                        ActionAddNote(
                            note: note))
                    
                    store.dispatch(
                        store.state.entryState.isEditingEntry ?
                            EntryThunk.updateEntry() :
                            EntryThunk.createNewEntry())
                    
                    store.dispatch(
                        ActionResetState())
                    
                    self.navigationController?.popToRootViewController(animated: true)
                })
            .disposed(by: self.disposeBag)
        
        self.navigationItem.rightBarButtonItem = barButton
        
        self.node.setNote(withNote: store.state.entryState.newEntryRequest.note)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }
    
    func newState(state: StoreSubscriberStateType) {
        self.node.tfNote.textView.text = store.state.entryState.newEntryRequest.note
    }
}
