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
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateSummary()
    }
    
    func updateSummary(){
        summary.text = Balance.summary()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("ExpenseCell") as! UITableViewCell
        
        let expense = array[indexPath.row]
        cell.textLabel?.text = "\(expense.amount) €"
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        let formattedDate = dateFormatter.stringFromDate(expense.date).uppercaseString
        
        let person:String
        if expense.personIndex == 0 {
            person = defaults.objectForKey(kUD_Person1) as? String ?? "1"
        }
        else {
            person = defaults.objectForKey(kUD_Person2) as? String ?? "2"
        }
        
        cell.detailTextLabel?.text = person + " " + expense.category + " "  + formattedDate
        
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

