import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var person1: UITextField!
    @IBOutlet weak var person2: UITextField!
    @IBOutlet weak var icloud: UISwitch!
    
    let textFieldShouldReturn = TextFieldShouldReturn()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPersonsNames()
        loadiCloudState()
    }
    
    func loadPersonsNames(){
        textFieldShouldReturn.addTextField(person1)
        textFieldShouldReturn.addTextField(person2)
        person1.text = k.Person1Name
        person2.text = k.Person2Name
    }
    
    func loadiCloudState(){
        icloud.on = k.isiCloudEnabled
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
    
    @IBAction func promptToDeleteAllExpenses() {
        var alert = UIAlertController(title: "Attention", message: "This will delete all your expenses", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action:UIAlertAction!) -> Void in
            RealmUtilities.deleteAllEntries()
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func icloud(sender: UISwitch) {
        k.Defaults.setObject(sender.on, forKey: k.UD_isiCloudEnabled)
        if sender.on {
            getURLforiCloudContainer()
        }
    }
    
    func getURLforiCloudContainer(){
            let background_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            dispatch_async(background_queue) {
                let fileManager = NSFileManager.defaultManager()

                if let myContainer = fileManager.URLForUbiquityContainerIdentifier("iCloud.com.tm.ExpensesBy2") {
                    // Your app can write to the iCloud container
                }
                let main_queue = dispatch_get_main_queue()
                dispatch_async(main_queue) {
                // main thread update ui
                }
            }
    }
}
