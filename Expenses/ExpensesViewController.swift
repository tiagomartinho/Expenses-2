import UIKit
import SwiftyDropbox
import RealmSwift

class ExpensesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var array = Realm().objects(Expense).sorted("date",ascending:false)
    var notificationToken: NotificationToken?

    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var expensesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupTableView()
        
        notificationToken = Realm().addNotificationBlock { [unowned self] note, realm in
            self.expensesTableView.reloadData()
        }
        
        expensesTableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateSummary()
    }
    
    func updateSummary(){
        if let person1Name = defaults.objectForKey(kUD_Person1) as? String, let person2Name = defaults.objectForKey(kUD_Person2) as? String {
            summary.text = person1Name + " owes " + person2Name + " 12.34€"
        }
    }
    
    func setupTableView(){
        self.expensesTableView.delegate = self;
        self.expensesTableView.dataSource = self;
    }
    
    @IBAction func linkDropbox(sender: UIBarButtonItem) {
        if Dropbox.authorizedClient == nil {
            Dropbox.authorizeFromController(self)
        }
    }
    
    // MARK: Tableview data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ExpenseCell") as! ExpenseCell
        
        let expense = array[indexPath.row]
        cell.textLabel?.text = "\(expense.amount) €"
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        let formattedDate = dateFormatter.stringFromDate(expense.date).uppercaseString
        cell.detailTextLabel?.text = expense.person + " " + expense.category + " "  + formattedDate
        
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

