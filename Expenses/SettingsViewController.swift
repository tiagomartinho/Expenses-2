import UIKit
import RealmSwift
import MessageUI
import Crashlytics

class SettingsViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var person1: UITextField!
    @IBOutlet weak var person2: UITextField!
    @IBOutlet weak var sendEmailActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var sendEmail: UIButton!
    
    let textFieldShouldReturn = TextFieldShouldReturn()
    
    // MARK : viewDidLoad
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
        
        Answers.logCustomEventWithName("Person Name Set", customAttributes:  nil)
    }
    
    @IBAction func promptToDeleteAllExpenses() {
        var alert = UIAlertController(title: "Attention", message: "This will delete all your expenses", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action:UIAlertAction!) -> Void in
            RealmUtilities.deleteAllEntries()
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK : Send Email
    
    @IBAction func sendByEmail() {
        startLoadAnimation()
        
        if(MFMailComposeViewController.canSendMail() ) {
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            mailComposer.setSubject("Expenses Backup")
            mailComposer.setMessageBody("To open the backup file in your Mac download the realm browser at:\n https://itunes.apple.com/app/realm-browser/id1007457278", isHTML: false)
            
            let filePath = Realm().path
            if let fileData = NSData(contentsOfFile: filePath) {
                mailComposer.addAttachmentData(fileData, mimeType: ".realm", fileName: "Expenses.realm")
            }
            
            self.presentViewController(mailComposer, animated: true) { [weak self] in
                if let settingsVC = self {
                    settingsVC.stopLoadAnimation()
                }
            }
        }
        else {
            stopLoadAnimation()
        }
    }
    
    func startLoadAnimation(){
        sendEmailActivityIndicator.startAnimating()
        sendEmail.hidden = true
    }
    
    func stopLoadAnimation(){
        sendEmailActivityIndicator.stopAnimating()
        sendEmail.hidden = false
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError) {
        if result.value == MFMailComposeResultSent.value {
            Answers.logCustomEventWithName("Expenses Exported", customAttributes:  nil)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
