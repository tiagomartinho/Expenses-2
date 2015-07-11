import UIKit
import RealmSwift

class ExpensesResultsTableController:UIViewController {
    var array = Realm().objects(Expense).sorted("date",ascending:false)

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("ExpenseCell") as? ExpensesTableViewCell {
            
            let expense = array[indexPath.row]
            
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
        else {
            return UITableViewCell()
        }
    }
}