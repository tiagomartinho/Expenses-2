import UIKit
import RealmSwift

class ExpensesResultsTableController:UITableViewController {
    var filteredExpenses:Results<Expense>?
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = filteredExpenses?.count {
            return count
        }
        return 0
    }
    
    override
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(kExpenseCell) as? ExpensesTableViewCell {
            
            if let expense = filteredExpenses?[indexPath.row] {
                
                cell.category = expense.category
                
                cell.amount = expense.amount.currency
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd/MM/YY"
                let formattedDate = dateFormatter.stringFromDate(expense.date).uppercaseString
                cell.date = formattedDate
                
                let person:String
                if expense.personIndex == 0 {
                    person = defaults.objectForKey(kUD_Person1) as? String ?? "1"
                }
                else {
                    person = defaults.objectForKey(kUD_Person2) as? String ?? "2"
                }
                
                cell.person = person
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
}