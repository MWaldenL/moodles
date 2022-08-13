import Foundation
import AsyncDisplayKit
import RxSwift
import ReSwift

class TagsViewController: BaseViewController {
    var tagsViewNode: TagsViewNode!
    
    override init(node: ASDisplayNode) {
        super.init(node: TagsViewNode())
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navTitle = store.state.entryState.isEditingEntry ?
            Constants.TITLE_ADD_TAGS :
            Constants.TITLE_EDIT_ENTRY
        self.navigationItem.hidesBackButton = false
        self.tagsViewNode = self.node as? TagsViewNode
        self.tagsViewNode.delegate = self
        
        // Set event listeners
        self.setEventListeners()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Show selected pills
        tagsViewNode.selectedPills = []
        for tag in store.state.entryState.newEntryRequest.tags {
            if let pill = tagsViewNode.pills.first(where: { $0.label == tag.tagName }) {
                pill.setColor(color: Styles.Color.orange)
                tagsViewNode.selectedPills.append(pill)
                tagsViewNode.pills.removeAll(where: { $0.label == pill.label })
            } else { // if this is an edited tag
                tagsViewNode.addToSelectedTags(with: tag.tagName) // add this new tag
                if let oldTagName = tag.oldTagName { // remove the old tag
                    tagsViewNode.removeFromTagCloud(with: oldTagName)
                }
            }
        }
        
        // Show unselected pills
        for tag in store.state.tagState.userTagRequests {
            if let oldName = tag.oldTagName {
                if let i = tagsViewNode.pills.firstIndex(where: { $0.label == oldName }) {
                    tagsViewNode.pills[i].label = tag.tagName
                }
            }
        }
        
        self.node.setNeedsLayout()
    }
    
    private func bindPillListeners(for pills: [ButtonPill]) {
        for pill in pills {
            pill.rxTap
                .subscribe(
                    onNext: { [weak self] in
                        self?.onPillClicked(pill: pill)
                    }
                )
                .disposed(by: self.disposeBag)
        }
    }
    
    private func setEventListeners() {
        // Unselected pills
        self.bindPillListeners(for: tagsViewNode.pills)
        self.bindPillListeners(for: tagsViewNode.selectedPills)
        
        // Add note
        tagsViewNode.btnAddNote.rxTap
            .subscribe(
                onNext: {
                    self.navigationController?.pushViewController(
                        AddNoteViewController(node: AddNoteViewNode()),
                        animated: true)
                })
            .disposed(by: self.disposeBag)
        
        // Done button
        tagsViewNode.btnDone.rxTap
            .subscribe(
                onNext: {
                    // UI update
//                    let newEntry = store.state.entryState.newEntryRequest
                    
                    // TODO: Might still want to keep this and find a way to pass the entry id in a queue
//                    let newTags = Set(newEntry.tags
//                        .filter { tag in !tag.fromUserTags}
//                        .map { tag in
//                            Tag(
//                                id: "",
//                                userId: store.state.authState.userId,
//                                entryIdSet: ["NEW_TAG_ENTRY": newEntry.moodLevel],
//                                tagName: tag.tagName,
//                                moodSet: [Int(newEntry.moodLevel): true],
//                                datesLogged: [newEntry.date],
//                                selected: false)
//                        })
//
//                    var arrTags = Array(store.state.tagState.allTagSet)
//                    for (i, _) in arrTags.enumerated() {
//                        let mood = Int(store.state.entryState.newEntryRequest.moodLevel)
//                        arrTags[i].entryIdSet[UUID().uuidString] = newEntry.moodLevel
//                        arrTags[i].moodSet[mood] = true // update mood value
//                    }
//                    let mergedTags = Set(arrTags).union(newTags)
//                    store.dispatch(ActionSetAllTags(tagSet: mergedTags))
//                    store.dispatch(ActionSetInsightTags(tagSet: mergedTags)) // set also in the insights side
//                    print(">>> TagsViewCVontroller: ", store.state.insightsState.allTags.map { $0.moodSet })
//                    print(">>> TagsViewCVontroller: ", store.state.insightsState.allTags.map { $0.entryIdSet })
//
//
                    
                    // Db update
                    store.dispatch(
                        store.state.entryState.isEditingEntry ?
                            EntryThunk.updateEntry() :
                            EntryThunk.createNewEntry())
                    store.dispatch(ActionResetState())
                    self.navigationController?.popToRootViewController(animated: true)
                })
            .disposed(by: self.disposeBag)
        
        // Add tag field
        tagsViewNode.tfTag.textField.textView.rx.text
            .subscribe(onNext: { text in
                guard let text = text else { return }
                self.tagsViewNode.tfTag.showButton = !text.isEmpty
                self.tagsViewNode.setNeedsLayout()
            })
            .disposed(by: self.disposeBag)
        
        tagsViewNode.tfTag.button.rxTap
            .subscribe(
                onNext: {
                    let tagName = self.tagsViewNode.tfTag.text
                    let tagExists = store.state.tagState.allTagSet
                        .contains(where: { $0.tagName == tagName })

                    // Add the tag to the request body
                    store.dispatch(
                        ActionAddTag(
                            tag: TagRequest(
                                tagName: tagName,
                                fromUserTags: tagExists)))
                    
                    // Add to selected tags and remove from tag cloud if it exists
                    self.tagsViewNode.addToSelectedTags(with: tagName)
                    if tagExists {
                        self.tagsViewNode.removeFromTagCloud(with: tagName)
                    }
                    
                    // Clear the text view
                    self.tagsViewNode.tfTag.textField.textView.text = ""
                    self.tagsViewNode.setNeedsLayout()
                })
            .disposed(by: self.disposeBag)
    }
}

extension TagsViewController: TagDelegate {
    func onTagAdded(fromPill pill: ButtonPill) {
        pill.rxTap.subscribe(
            onNext: { [weak self] in
                self?.onPillClicked(pill: pill)
            }
        )
        .disposed(by: self.disposeBag)
    }
}

//- MARK: Event listeners
extension TagsViewController {
    private func onPillClicked(pill: ButtonPill) {
        // Show the full list of tags
        if pill.label == "..." {
            self.navigationController?.pushViewController(
                TagListController(node: TagListViewNode()),
                animated: true)
        } else {
            let selectedTag = store.state.tagState.userTagRequests.first(
                where: { $0.tagName == pill.label }) ??
                    TagRequest(tagName: pill.label)
            
            let selected = store.state.entryState.newEntryRequest.tags.contains(where: { tag in
                tag.tagName == selectedTag.tagName
            })
            
            // Add the tag pill to the top list
            if selected {
                store.dispatch(
                    ActionDeselectTag(
                        tag: selectedTag))
                
                pill.setColor(color: .black)
                
                // Add to tag cloud and remove from selected
                tagsViewNode.pills.insert(pill, at: tagsViewNode.pills.count - 1)
                tagsViewNode.selectedPills.removeAll(where: { $0.label == selectedTag.tagName })
            } else {
                store.dispatch(
                    ActionSelectTag(
                        tag: selectedTag))
                
                pill.setColor(color: Styles.Color.orange)
                
                // Add to selected and remove from tag cloud
                tagsViewNode.selectedPills.append(pill)
                tagsViewNode.pills.removeAll(where: { $0.label == selectedTag.tagName })
            }
                
            self.node.setNeedsLayout()
        }
    }
}
