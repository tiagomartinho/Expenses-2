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
    
    @IBAction func person(_ sender: UITextField) {
        let name = sender.text?.removeWhitespaces()
        
        if sender.placeholder?.hasSuffix("default_person_1_name".localized) ?? false {
            if name == "" {
                k.Defaults.removeObject(forKey: k.UD_Person1)
            }
            else {
                k.Defaults.set(name, forKey: k.UD_Person1)
            }
        }
        
        if sender.placeholder?.hasSuffix("default_person_2_name".localized) ?? false {
            if name == "" {
                k.Defaults.removeObject(forKey: k.UD_Person2)
            }
            else {
                k.Defaults.set(name, forKey: k.UD_Person2)
            }
        }
        
        k.Defaults.synchronize()
        
        Answers.logCustomEvent(withName: "Person Name Set", customAttributes:  nil)
    }
    
    @IBAction func promptToDeleteAllExpenses() {
        let alert = UIAlertController(title: "attention".localized, message: "erase_warning".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: { (action:UIAlertAction!) -> Void in
            RealmUtilities.deleteAllEntries()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK : Send Email
    
    @IBAction func sendByEmail() {
        startLoadAnimation()
        
        if(MFMailComposeViewController.canSendMail() ) {
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            mailComposer.setSubject("Expenses Backup")
            mailComposer.setMessageBody("To open the backup file in your Mac download the realm browser at:\n https://itunes.apple.com/app/realm-browser/id1007457278", isHTML: false)
            
            let realm = try! Realm()
            let filePath = realm.configuration.fileURL!
            if let fileData = try? Data(contentsOf: filePath) {
                mailComposer.addAttachmentData(fileData, mimeType: ".realm", fileName: "Expenses.realm")
            }
            
            self.present(mailComposer, animated: true) { [weak self] in
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
        sendEmail.isHidden = true
    }
    
    func stopLoadAnimation(){
        sendEmailActivityIndicator.stopAnimating()
        sendEmail.isHidden = false
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if result == MFMailComposeResult.sent {
            Answers.logCustomEvent(withName: "Expenses Exported", customAttributes:  nil)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
