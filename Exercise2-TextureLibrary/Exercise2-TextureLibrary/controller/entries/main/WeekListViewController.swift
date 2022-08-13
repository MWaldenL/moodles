import Foundation
import AsyncDisplayKit
import UIKit


class WeekListViewController: ASDKViewController<WeekViewNode> {
    var weeks: [String: [String]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.node.weekList.dataSource = self
        self.node.weekList.delegate = self
        
        // Populate the weeks map
        for i in 1...12 {
            let lastDay = DateService.daysInMonth(month: i, year: 2022) // temp hardcode 2022 for now
            let month = Constants.MONTHS[i]
            weeks[month] = [
                DateService.weekString(month: i, startDay: 1, endDay: 7),
                DateService.weekString(month: i, startDay: 8, endDay: 14),
                DateService.weekString(month: i, startDay: 15, endDay: 21),
                DateService.weekString(month: i, startDay: 22, endDay: lastDay)
            ]
        }
    }
}

extension WeekListViewController: ASCommonTableDataSource, ASTableDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Constants.MONTHS[section + 1]
    }
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return weeks.count
    }

    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        let month = Constants.MONTHS[section]
        guard let week = self.weeks[month] else { return 4 }
        return week.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cell = WeekCell()
        let i = indexPath.row
        let month = Constants.MONTHS[indexPath.section + 1]
        cell.weekName = self.weeks[month]![i]
        return cell
    }
}

extension WeekListViewController: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let monthNum = indexPath.section + 1
        let month = Constants.MONTHS[monthNum]
        let weekTokens = self.weeks[month]![indexPath.row].split(separator: " ")
        
        guard let startDay = Int(weekTokens[1]),
              let endDay = Int(weekTokens.last!)
        else {
            print("Invalid start and end days")
            return
        }
        
        let week = Week(
            month: monthNum,
            startDay: startDay,
            endDay: endDay)
        store.dispatch(
            ActionSetCurrentWeek(
                week: week))
        store.dispatch(
            EntryThunk.fetchEntriesByWeek(week: week))
        
        self.navigationController?.popToRootViewController(animated: true)
    }
}
