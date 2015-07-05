import UIKit
import SwiftyDropbox
import RealmSwift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var array = Realm().objects(Expense).sorted("date")
    var notificationToken: NotificationToken?

    @IBOutlet weak var expensesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set realm notification block
        notificationToken = Realm().addNotificationBlock { [unowned self] note, realm in
            self.expensesTableView.reloadData()
        }
        
        expensesTableView.reloadData()
    }
    
    @IBAction func linkDropbox(sender: UIBarButtonItem) {
        if Dropbox.authorizedClient == nil {
            Dropbox.authorizeFromController(self)
        }
    }
    
    @IBAction func composeExpense(sender: UIBarButtonItem) {
        addRandomExpense()
    }
    
    func addRandomExpense() {
        let realm = Realm()
        realm.beginWrite()
        let date = NSDate()
        let amount = 0
        realm.create(Expense.self, value: [amount, date])
        realm.commitWrite()
    }
    
    // MARK: Tableview data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ExpenseCell
        
        let expense = array[indexPath.row]
        cell.textLabel?.text = "\(expense.amount)"
        cell.detailTextLabel?.text = expense.date.description
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let realm = Realm()
            realm.beginWrite()
            realm.delete(array[indexPath.row])
            realm.commitWrite()
        }
    }
}

