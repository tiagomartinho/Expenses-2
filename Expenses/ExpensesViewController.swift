import UIKit
import RealmSwift

class ExpensesViewController: UIViewController, UITableViewDataSource {
    
    var array = Realm().objects(Expense).sorted("date",ascending:false)
    var notificationToken: NotificationToken?
    
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var expensesTableView: UITableView!
    @IBOutlet weak var initialView: UIView!
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewDataSource()
        setNotificationsForRealmUpdates()
    }
    
    func setTableViewDataSource(){
        self.expensesTableView.dataSource = self;
    }
    
    func setNotificationsForRealmUpdates(){
        notificationToken = Realm().addNotificationBlock { [unowned self] note, realm in
            self.updateUI()
        }
    }
    
    // MARK: viewDidAppear
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
    }
    
    func updateUI(){
        updateSummary()
        showInitialViewIfThereAreNoExpenses()
        expensesTableView.reloadData()
    }
    
    func updateSummary(){
        summary.text = Balance.summary()
    }
    
    func showInitialViewIfThereAreNoExpenses(){
        let thereAreNoExpenses = array.count == 0
        initialView.hidden = thereAreNoExpenses ? false : true
    }
    
    // MARK: TableView Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(kExpenseCell) as? ExpensesTableViewCell {
            
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
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let realm = Realm()
            realm.beginWrite()
            realm.delete(array[indexPath.row])
            realm.commitWrite()
        }
    }
}

