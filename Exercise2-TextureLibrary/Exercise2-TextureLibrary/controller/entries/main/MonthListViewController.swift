import Foundation
import AsyncDisplayKit


class MonthListViewController: ASDKViewController<MonthViewNode> {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.node.monthList.dataSource = self
        self.node.monthList.delegate = self
    }
}

extension MonthListViewController: ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cell = MonthCell()
        cell.monthName = Constants.MONTHS[indexPath.row]
        return cell
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return Constants.MONTHS.count
    }
}

extension MonthListViewController: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        store.dispatch(
            EntryThunk.fetchEntriesByMonth(
                month: indexPath.row))
        self.navigationController?.popToRootViewController(animated: true)
    }
}
