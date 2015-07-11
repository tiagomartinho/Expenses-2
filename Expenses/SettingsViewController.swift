import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var person1: UITextField!
    @IBOutlet weak var person2: UITextField!
    
    let textFieldShouldReturn = TextFieldShouldReturn()

    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldShouldReturn.addTextField(person1)
        textFieldShouldReturn.addTextField(person2)
        loadPersonsNames()
    }
    
    func loadPersonsNames(){
        if let person1Name = defaults.objectForKey(kUD_Person1) as? String {
            person1.text = person1Name
        }
        if let person2Name = defaults.objectForKey(kUD_Person2) as? String {
            person2.text = person2Name
        }
    }
    
    @IBAction func person(sender: UITextField) {
        let name = sender.text.removeWhitespaces()
        if name == "" {
            return
        }
        
        if sender.placeholder?.hasSuffix("1") ?? false {
            defaults.setObject(name, forKey: kUD_Person1)
        }
        
        if sender.placeholder?.hasSuffix("2") ?? false {
            defaults.setObject(name, forKey: kUD_Person2)
        }
        
        defaults.synchronize()
    }
    
    @IBAction func promptToDeleteAllExpenses() {
        var alert = UIAlertController(title: "Attention", message: "This will delete all your expenses", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action:UIAlertAction!) -> Void in
            RealmUtilities.deleteAllEntries()
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
