import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var person1: UITextField!
    @IBOutlet weak var person2: UITextField!
    
    @IBOutlet weak var uploadDropbox: UITableViewCell!
    @IBOutlet weak var linkDropbox: UITableViewCell!
    
    let textFieldShouldReturn = TextFieldShouldReturn()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPersonsNames()
    }
    
    func loadPersonsNames(){
        textFieldShouldReturn.addTextField(person1)
        textFieldShouldReturn.addTextField(person2)
        person1.text = k.Person1Name
        person2.text = k.Person2Name
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setVisibilityOfDropboxActions()
    }
    
    func setVisibilityOfDropboxActions(){
        uploadDropbox.hidden = k.isLinked ? false : true
        linkDropbox.hidden = k.isLinked ? true : false
    }

    @IBAction func person(sender: UITextField) {
        let name = sender.text.removeWhitespaces()
        
        if sender.placeholder?.hasSuffix("1") ?? false {
            if name == "" {
                k.Defaults.removeObjectForKey(k.UD_Person1)
            }
            else {
                k.Defaults.setObject(name, forKey: k.UD_Person1)
            }
        }
        
        if sender.placeholder?.hasSuffix("2") ?? false {
            if name == "" {
                k.Defaults.removeObjectForKey(k.UD_Person2)
            }
            else {
                k.Defaults.setObject(name, forKey: k.UD_Person2)
            }
        }
        
        k.Defaults.synchronize()
    }
    
    @IBAction func uploadToDropbox() {
    }
    
    @IBAction func linkWithDropbox() {
        if k.isLinked == false {
            k.sharedSession.linkFromController(self)
        }
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
