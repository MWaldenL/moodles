import Foundation
import AsyncDisplayKit
import UIKit
import ReSwift


class TagListController: ASDKViewController<TagListViewNode> {
    var unselectedPills = store.state.tagState.userTagRequests
        .subtracting(store.state.entryState.newEntryRequest.tags)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.node.tagList.dataSource = self
        self.node.tagList.delegate = self
        
        self.navigationItem.title = Constants.TITLE_ALL_TAGS
        self.node.tagList.view.separatorStyle = .none
    }
}
