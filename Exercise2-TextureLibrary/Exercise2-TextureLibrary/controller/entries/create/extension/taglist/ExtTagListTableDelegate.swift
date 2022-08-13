import Foundation
import AsyncDisplayKit
import UIKit
import ReSwift


//- MARK: Tableview delegate methods
extension TagListController: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let tag = Array(unselectedPills)[indexPath.row]
        let cell = tableNode.view.nodeForRow(at: indexPath) as! TagCell
        cell.tvName.view.clipsToBounds = true
        
        if store.state.entryState.newEntryRequest.tags.contains(tag) {
            store.dispatch(
                ActionDeselectTag(tag: tag))
            cell.tvName.view.backgroundColor = .white
        } else {
            store.dispatch(
                ActionSelectTag(tag: tag))
            cell.tvName.view.backgroundColor = Styles.Color.orange1
        }
    }
}
