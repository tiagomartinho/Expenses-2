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
        let thereAreNoExpenses = (array.count == 0)
        initialView.hidden = thereAreNoExpenses ? false : true
    }
    
    // MARK: TableView Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(kExpenseCell) as? ExpensesTableViewCell {
            
            let expense = array[indexPath.row]
            cell.person = personForIndex(expense.personIndex)
            cell.category = expense.category
            cell.amount = expense.amount.currency
            cell.date = formatDate(expense.date)

            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    func personForIndex(index:Int)->String{
        if index == 0 {
            return defaults.objectForKey(kUD_Person1) as? String ?? "1"
        }
        else {
            return defaults.objectForKey(kUD_Person2) as? String ?? "2"
        }
    }
    
    func formatDate(date: NSDate)->String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        return dateFormatter.stringFromDate(date).uppercaseString
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let entry = array[indexPath.row]
            RealmUtilities.deleteEntry(entry)
        }
    }
}

