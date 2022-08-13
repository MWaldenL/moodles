import Foundation
import AsyncDisplayKit
import UIKit
import ReSwift


//- MARK: Tableview data source methods
extension TagListController: ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let tag = Array(unselectedPills)[indexPath.row]
        return TagCell(label: tag.tagName)
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.unselectedPills.count
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions in
            
            // Edit tag
            let editAction = UIAction(
                title: "Edit",
                image: UIImage(systemName: "doc.on.doc")) { action in
                    var textField = UITextField()
                    
                    let alertDialog = UIAlertController(
                        title: "Edit Tag",
                        message: "",
                        preferredStyle: .alert)
                    
                    // Confirm edit
                    let confirmAction = UIAlertAction(
                        title: "Edit Name",
                        style: .default,
                        handler: { action in
                            let pills = Array(self.unselectedPills)
                            let oldName = pills[indexPath.row].tagName
                            let newName = textField.text!
                            guard oldName != newName else { return } // prevent duplicate tag names
                            
                            // Update UI
                            self.unselectedPills.remove(
                                TagRequest(tagName: oldName, fromUserTags: true))
                            
                            self.unselectedPills.update(
                                with: TagRequest(
                                    tagName: newName,
                                    oldTagName: oldName,
                                    fromUserTags: true))
                            
                            self.node.tagList.reloadData()
                            
                            store.dispatch(
                                ActionUpdateTag(
                                    oldName: oldName,
                                    newName: newName))
                            
                            // Update db
                            store.dispatch(
                                TagThunk.updateTag(
                                    oldName: oldName,
                                    newName: newName))
                        })
                    
                    // Cancel edit
                    let cancelAction = UIAlertAction(
                        title: "Cancel",
                        style: .cancel,
                        handler: { action in
                            alertDialog.dismiss(animated: true)
                        })
                    
                    
                    alertDialog.addTextField { tf in
                        tf.placeholder = "e.g. Happy"
                        textField = tf
                    }
                    alertDialog.addAction(cancelAction)
                    alertDialog.addAction(confirmAction)
                    self.present(alertDialog, animated: true, completion: nil)
                }
            
            // Delete action
            let deleteAction = UIAction(
                title: "Delete",
                image: UIImage(systemName: "trash")) { action in
                    let alertDialog = UIAlertController(
                        title: "Delete Tag",
                        message: "Are you sure to delete this tag?",
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
                            let tagName = Array(self.unselectedPills)[indexPath.row].tagName
                            
                            // UI update
                            self.unselectedPills = self.unselectedPills.filter {
                                $0.tagName != tagName
                            }
                            store.dispatch(
                                ActionDeleteTag(
                                    name: tagName))
                            
                            self.node.tagList.reloadData()
                            
                            // DB update
                            store.dispatch(
                                TagThunk.deleteTag(
                                    name: tagName))
                        })
                    
                    alertDialog.addAction(cancelAction)
                    alertDialog.addAction(deleteAction)
                    self.present(alertDialog, animated: true, completion: nil)
                }
            
            return UIMenu(title: "", children: [editAction, deleteAction])
        }
    }
}
